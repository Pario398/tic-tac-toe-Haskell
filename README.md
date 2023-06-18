# Tic-Tac-Toe Game Documentation

## Introduction
This documentation provides an overview and usage instructions for the tic-tac-toe game implemented in Haskell.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Functions](#functions)
  - [pickRandom](#pickrandom)
  - [convertInputToIndex](#convertinputtoindex)
  - [printBoard](#printboard)
  - [checkMoveLegal](#checkmovelegal)
  - [boolToIntList](#booltointlist)
  - [winningCombinations](#winningcombinations)
  - [getOutcome](#getoutcome)
  - [getLegalMoves](#getlegalmoves)
  - [humanPlayer](#humanplayer)
  - [botPlayer](#botplayer)
  - [indextoInput](#indextoinput)
  - [gameManager](#gamemanager)
  - [gameStart](#gamestart)
  - [createPlayer](#createplayer)

## Installation
To use the tic-tac-toe game, make sure you have Haskell installed on your system. Then, follow these steps:
1. Clone the repository: `git clone https://github.com/your/repository.git`
2. Change to the project directory: `cd repository`
3. Build the project: `stack build`
4. Run the game: `stack run`

## Usage
Once the game is running, you can choose from the following options:
- Bot vs Player: `gameStart True False`
- Player vs Bot: `gameStart False True`
- Bot vs Bot: `gameStart True True`
- Player vs Player: `gameStart False False`

## Functions

### `pickRandom`
- Description: Picks a random element from a list of integers.
- Signature: `pickRandom :: [Int] -> IO Int`

Example:
```haskell
-- Pick a random element from the list
let xs = [1, 2, 3, 4, 5]
pickRandom xs -- Returns: 3
```
### `convertInputToIndex`
- Description: Converts user input to the corresponding board index.
- Signature: `convertInputToIndex :: String -> Maybe Int`

Example:
```haskell
-- Convert user input to board index
convertInputToIndex "B2" -- Returns: Just 4
```
### `printBoard`
- Description: Prints the Tic-Tac-Toe board to the console.
- Signature: `printBoard :: Board -> IO ()`

Example:
```haskell
-- Print the Tic-Tac-Toe board
let board = [1, 2, 0, 0, 1, 2, 2, 0, 1]
printBoard board--Returns:"|X| |O| | | | | |X| |O| |O| | | |X|"
```
### `checkMoveLegal`

- Description: Checks if a move is legal on the Tic-Tac-Toe board.
- Signature: `checkMoveLegal :: Board -> Move -> Maybe Board`

Example:
```haskell
-- Check if a move is legal
let board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
let move = (True, 4)
checkMoveLegal board move -- Returns: Just [0, 0, 0, 0, 1, 0, 0, 0, 0]
```
### `boolToIntList`

- Description: Converts a Boolean value to a list of integers.
- Signature: `boolToIntList :: Bool -> [Int]`

Example:
```haskell
-- Convert a Boolean value to a list of integers
boolToIntList True -- Returns: [1]
boolToIntList False -- Returns: [2]
```
### `winningCombinations`

- Description: Represents the winning combinations in a Tic-Tac-Toe game.
- Signature: `winningCombinations :: [[Int]]`

Example:
```haskell
-- Get the winning combinations
winningCombinations -- Returns: [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [6, 4, 2]]
```
### `getOutcome`

- Description: Determines the outcome of a Tic-Tac-Toe game based on the current state of the board.
- Signature: `getOutcome :: Board -> Maybe Outcome`

Example:
```haskell
-- Get the outcome of the game
let board = [1, 2, 1, 2, 1, 2, 0, 0, 0]
getOutcome board -- Returns: Just (Win True)

let board = [1, 1, 2, 2, 2, 1, 1, 2, 1]
getOutcome board -- Returns: Just (Win False)

let board = [1, 2, 1, 2, 1, 2, 2, 1, 2]
getOutcome board -- Returns: Just Draw

let board = [1, 2, 0, 0, 0, 0, 0, 0, 0]
getOutcome board -- Returns: Nothing
```
### `getLegalMoves`

- Description: Retrieves the legal moves from a Tic-Tac-Toe board.
- Signature: `getLegalMoves :: Board -> [Int] -> Int -> [Int]`

Example:
```haskell
-- Get the legal moves from the board
let board = [1, 0, 2, 0, 1, 0, 0, 2, 0]
getLegalMoves board [] 0 -- Returns: [1, 3, 5, 6, 7, 8]

let board = [1, 1, 2, 2, 2, 1, 1, 2, 1]
getLegalMoves board [] 0 -- Returns: []

let board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
getLegalMoves board [] 0 -- Returns: [0, 1, 2, 3, 4, 5, 6, 7, 8]
```
### `humanPlayer`

- Description: Allows a human player to make a move in the Tic-Tac-Toe game.
- Signature: `humanPlayer :: Player -> IO ()`

Example:
```haskell
-- Initialize the player and let a human player make a move
let player = (True, inputChan, outputChan)
humanPlayer player
```
### `botPlayer`

- Description: Allows a bot player to make a move in the Tic-Tac-Toe game.
- Signature: `botPlayer :: Player -> IO ()`

Example:
```haskell
-- Initialize the player and let a bot player make a move
let player = (False, inputChan, outputChan)
botPlayer player
```
### `indextoInput`

- Description: Converts an index value to the corresponding Tic-Tac-Toe board position.
- Signature: `indextoInput :: Int -> Maybe String`

Example:
```haskell
-- Convert an index to the corresponding board position
indextoInput 0 -- Returns: Just "A1"
indextoInput 4 -- Returns: Just "B2"
indextoInput 8 -- Returns: Just "C3"
indextoInput 9 -- Returns: Nothing
```
### `gameManager`

- Description: Manages the game flow and player turns in the Tic-Tac-Toe game.
- Signature: `gameManager :: Board -> Bool -> Player -> Bool -> Player -> Bool -> IO ()`


Example:
```haskell
-- Initialize the players and start the game
let board = startBoard
let playerA = (True, inputChanA, outputChanA)
let playerB = (False, inputChanB, outputChanB)
gameManager board True playerA True playerB False
```
### `gameStart`

- Description: Starts the Tic-Tac-Toe game with the specified player configurations.
- Signature: `gameStart :: Bool -> Bool -> IO ()`

Example:

```haskell
-- Start the game with a human player (Player A) against a bot player (Player B)
gameStart True False
-- Start the game with a bot player (Player A) against a human player (Player B)
gameStart False True
-- Start the game with two bot players
gameStart True True
-- Start the game with two human players
gameStart False False
```

### `createPlayer`

- Description: Creates a player for the Tic-Tac-Toe game with the specified symbol and player type.
- Signature: `createPlayer :: String -> Bool -> IO (Chan Msg, Chan Msg, Player)`

Example:
```haskell
-- Create a human player with symbol "X"
let isBot = False
let symbol = "X"
createPlayer symbol isBot
```
