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
Description: Picks a random element from a list of integers.

Signature: `pickRandom :: [Int] -> IO Int`

Example:
```haskell
-- Pick a random element from the list
let xs = [1, 2, 3, 4, 5]
pickRandom xs -- Returns: 3
```
### `convertInputToIndex`
Description: Converts user input to the corresponding board index.

Signature: `convertInputToIndex :: String -> Maybe Int`

Example:
```haskell
-- Convert user input to board index
convertInputToIndex "B2" -- Returns: Just 4
```
### `printBoard`

Description: Prints the Tic-Tac-Toe board to the console.

Signature: `printBoard :: Board -> IO ()`

Example:
```haskell
-- Print the Tic-Tac-Toe board
let board = [1, 2, 0, 0, 1, 2, 2, 0, 1]
printBoard board--Returns:"|X| |O| | | | | |X| |O| |O| | | |X|"
```
