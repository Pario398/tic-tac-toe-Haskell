module PickRandom (pickRandom) where

import Control.Concurrent
import Data.Bits
import Data.Char
import Data.Time.Clock.System
import System.Exit

pickRandom :: [Int] -> IO Int
pickRandom [] = undefined
pickRandom [x] = return x
pickRandom xs = do
  t <- getSystemTime
  let n = systemNanoseconds t
  let nn = fromIntegral (shiftR (n * 123456789) 16)
  let m = length xs
  return (xs !! (mod nn m))


type Board = [Int]

type Move = (Bool, Int)

data Outcome = Win Bool | Draw
  deriving (Show)

convertInputToIndex :: String -> Maybe Int
convertInputToIndex input = case input of
  "A1" -> Just 0
  "A2" -> Just 1
  "A3" -> Just 2
  "B1" -> Just 3
  "B2" -> Just 4
  "B3" -> Just 5
  "C1" -> Just 6
  "C2" -> Just 7
  "C3" -> Just 8
  "a1" -> Just 0
  "a2" -> Just 1
  "a3" -> Just 2
  "b1" -> Just 3
  "b2" -> Just 4
  "b3" -> Just 5
  "c1" -> Just 6
  "c2" -> Just 7
  "c3" -> Just 8
  _ -> Nothing

printBoard :: Board -> IO ()
printBoard board = do
  addCell (take 3 board)
  addCell (take 3 (drop 3 board))
  addCell (drop 6 board)
  putStrLn "The index of the board is: A1-C3"

addCell :: Board -> IO ()
addCell [] = putStrLn ""
addCell (cell : cells) = do
  case cell of
    0 -> putStr "|_|"
    1 -> putStr "|X|"
    2 -> putStr "|O|"
    _ -> error "Invalid cell"
  addCell cells

checkMoveLegal :: Board -> Move -> Maybe Board
checkMoveLegal board (player, index)
  | not (isValidIndex index) = Nothing
  | isOccupied index = Nothing
  | otherwise = Just (makeMove player index board)
  where
    isValidIndex i = i >= 0 && i <= 8
    isOccupied i = board !! i /= 0
    makeMove p i b = take i b ++ boolToIntList p ++ drop (i + 1) b

boolToIntList :: Bool -> [Int]
boolToIntList True = [1]
boolToIntList False = [2]

winningCombinations :: [[Int]]
winningCombinations =
  [ [0, 1, 2],[3, 4, 5],[6, 7, 8], 
    [0, 3, 6],[1, 4, 7],[2, 5, 8], 
    [0, 4, 8],[6, 4, 2] 
  ]

getOutcome :: Board -> Maybe Outcome
getOutcome board
  | any (winningCombinationForPlayer 1) winningCombinations = Just (Win True)
  | any (winningCombinationForPlayer 2) winningCombinations = Just (Win False)
  | any (== 0) board = Nothing
  | otherwise = Just Draw
  where
    winningCombinationForPlayer :: Int -> [Int] -> Bool
    winningCombinationForPlayer player = all (\pos -> board !! pos == player)

data Msg = Invitation Board | Message Move

type Player = (Bool, Chan Msg, Chan Msg)

getLegalMoves :: Board -> [Int] -> Int -> [Int]
getLegalMoves [] acc _ = acc
getLegalMoves (x : xs) acc index
  | x == 0 = getLegalMoves xs (acc ++ [index]) (index + 1)
  | otherwise = getLegalMoves xs acc (index + 1)

humanPlayer :: Player -> IO ()
humanPlayer (player, inChan, outChan) = do
  Invitation board <- readChan inChan
  printBoard board
  num <- getLegalUserInput board
  writeChan outChan (Message (player, num))

getLegalUserInput :: Board -> IO Int
getLegalUserInput board = do
  input <- getLine
  case convertInputToIndex input of
    Just num -> do
      let moves = getLegalMoves board [] 0
      if num `elem` moves
        then return num
        else do
          putStrLn "Invalid/illegal move"
          getLegalUserInput board
    Nothing -> do
      putStrLn "Invalid input"
      getLegalUserInput board


botPlayer :: Player -> IO ()
botPlayer (player, inputChan, outputChan) = do
  Invitation board <- readChan inputChan
  
  let legalMoves = getLegalMoves board [] 0
  
  chosenIndex <- case length legalMoves of
    0 -> error "No legal moves"
    1 -> return $ head legalMoves
    _ -> pickRandom legalMoves
  
  printBoard board
  let chosenMove = case indextoInput chosenIndex of
        Just move -> move
        Nothing -> "invalid move"
  putStrLn $ "Bot player " ++ (if player then "X" else "O") ++ " has made a move at " ++ chosenMove
  
  writeChan outputChan (Message (player, chosenIndex))
  return ()

indextoInput :: Int -> Maybe String
indextoInput index = case index of
  0 -> Just "A1"
  1 -> Just "A2"
  2 -> Just "A3"
  3 -> Just "B1"
  4 -> Just "B2"
  5 -> Just "B3"
  6 -> Just "C1"
  7 -> Just "C2"
  8 -> Just "C3"
  _ -> Nothing

gameManager :: Board -> Bool -> Player -> Bool -> Player  -> Bool -> IO ()
gameManager board whosTurn (roleA, inputA, outputA) isPlayerA (roleB, inputB, outputB) isPlayerB =
  let (currentRole, currentInput, currentOutput, winSymbol) =
        if whosTurn
          then (roleA, inputA, outputA, 'X')
          else (roleB, inputB, outputB, 'O')
   in do
        writeChan currentInput $ Invitation board 
        if isPlayerA && whosTurn || isPlayerB && not whosTurn 
          then botPlayer (currentRole, currentInput, currentOutput) 
          else humanPlayer (currentRole, currentInput, currentOutput) 
        Message move <- readChan currentOutput 
        case checkMoveLegal board move of
          Just newBoard -> do
            case getOutcome newBoard of
              Just outcome -> do 
                case outcome of
                  Win _ -> putStrLn (winSymbol : " Won") >> exitSuccess 
                  Draw -> putStrLn "Draw" >> exitSuccess
              Nothing ->
                gameManager newBoard (not whosTurn) (roleA, inputA, outputA) isPlayerA (roleB, inputB, outputB) isPlayerB 
          Nothing -> error "invalid Move"

gameStart :: Bool -> Bool -> IO ()
gameStart isPlayerA isPlayerB = do
  (inputA, outputA, roleA) <- createPlayer "X" isPlayerA
  (inputB, outputB, roleB) <- createPlayer "O" isPlayerB
  gameManager startBoard True roleA isPlayerA roleB isPlayerB

createPlayer :: String -> Bool -> IO (Chan Msg, Chan Msg, Player)
createPlayer symbol isBot = do
  input <- newChan :: IO (Chan Msg)
  output <- newChan :: IO (Chan Msg)
  let player = if isBot then botPlayer else humanPlayer
  let role = (symbol == "X", input, output)
  putStrLn $ symbol ++ if isBot then " - Bot" else " - Human"
  return (input, output, role)

startBoard :: Board
startBoard =
  [ 0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]


-- Bot vs Player
-- gameStart True False
-- Player vs Bot
-- gameStart False True
-- Bot vs Bot
-- gameStart True True
-- Player vs Player
-- gameStart False False
