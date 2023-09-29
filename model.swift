//
//  model.swift
//  assign1
//
//  Created by Ndenko Benanzea-Fontem on 2/25/23.
//

import Foundation
//observable object make triples visible to contentview. im not sure if
//this is the only way to do it
class Triples : ObservableObject
{
    //i believe this makes it so that if the variable changes, the view will update
    @Published var board: [[Tile?]]
    //create random generator with seed 14
    var seededGenerator = SeededGenerator(seed: 14)
    var score: Int = 0
    var curr_id = 0
    public struct Tile: Equatable
    {
        var val: Int
        var id: Int
        //        var row: Int
        //        var col: Int
    }
    enum Direction
    {
        case up
        case down
        case left
        case right
    }
    
    init()
    {
      
        curr_id = 0
        score = 0
        board = Array(repeating: Array(repeating: nil, count: 4), count: 4)
        
        
    }
    
    // re-inits 'board', and any other state you define
    private func newgame()
    {
        curr_id = 0
        score = 0
        board = Array(repeating: Array(repeating: nil, count: 4), count: 4)
    }
    //a new game re-initializes the seededGenerator
    public func newgame(rand: Bool)
    {
        curr_id = 0
        score = 0
        //deterministic
        if rand == false
        {
            seededGenerator = SeededGenerator(seed: 14)
            board = Array(repeating: Array(repeating: nil, count: 4), count: 4)
            spawn()
            spawn()
            spawn()
            spawn()
        }
        //random
        else
        {
            
            seededGenerator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
            board = Array(repeating: Array(repeating: nil, count: 4), count: 4)
            spawn()
            spawn()
            spawn()
            spawn()
        }
        
    }
    //checks if 2 values can be "collapsed" without issue
    public func isPossible(_ val1: Tile, _ val2: Tile) -> Bool
    {
        //valid if eliminating a blank, combining a 1 and a 2, or
        //combining two consecutive tiles w/ the same value, 3 or higher.
        
        if (val1.val == 0 || val2.val == 0 || (val1.val == 1 && val2.val == 2) || (val1.val == 2 && val2.val == 1) || (val1.val == val2.val && val1.val >= 3))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    // rotate a square 2D Int array clockwise
    func rotate()
    {
        board = rotate2D(input: board)
    }
    
    // collapse to the left
    func shift()
    {
        var row = 0
        var col = 0
        while row < board.count
        {
            col = 0
            //we do -1 so we don't go out of bounds
            while col < board.count-1
            {
                //conditionally unwrap the 2 tile optionals
                
                if let tile1 = board[row][col]
                {
                    //no else here, purposefully dont do anything if the second is nil
                    if let tile2 = board[row][col+1]
                    {
                        if (isPossible(tile1, tile2))
                        {
                            //if neither of these combinations were 0, add the combination to the total score
                            if tile1.val != 0 && tile2.val != 0
                            {
                                score += tile1.val + tile2.val
                            }
                            //                            shift the sum of values to the left
                            board[row][col]!.val = board[row][col]!.val + board[row][col+1]!.val
                            //                            shift the id that we keep to the left
                            board[row][col]!.id = board[row][col+1]!.id
                            //                            forget about the one on the right
                            board[row][col+1] = nil
                            
                        }
                    }
                }
                //if it turns out the first tile is nil, shift the seconds tile down 1
                else
                {
                    board[row][col] = board[row][col+1]
                    board[row][col+1] = nil
                }
                
                col += 1
            }
            row += 1
            
        }
    }
    
    // collapse in specified direction using shift() and rotate()
    private func collapse(dir: Direction)
    {
        if dir == Direction.left
        {
            shift()
        }
        else if dir == Direction.right
        {
            rotate()
            rotate()
            shift()
            rotate()
            rotate()
            
        }
        else if dir == Direction.up
        {
            rotate()
            rotate()
            rotate()
            shift()
            rotate()
            
            
        }
        else if dir == Direction.down
        {
            rotate()
            shift()
            rotate()
            rotate()
            rotate()
        }
        
    }
    //returns true if movement occured otherwise false
    public func collapse(dir: Direction) -> Bool
    {
        var original_arr: [[Tile?]] = board
        if dir == Direction.left
        {
            shift()
        }
        else if dir == Direction.right
        {
            rotate()
            rotate()
            shift()
            rotate()
            rotate()
        }
        else if dir == Direction.up
        {
            rotate()
            rotate()
            rotate()
            shift()
            rotate()
            
        }
        else if dir == Direction.down
        {
            rotate()
            shift()
            rotate()
            rotate()
            rotate()
        }
        //board no longer being the same as the original, before the attempted
        //shifts indicates movement occured
        var row = 0
        var col = 0
        while row < original_arr.count
        {
            while col < original_arr[0].count
            {
                if original_arr[row][col] != board[row][col]
                {
                    //                    spawn()
                    return true
                }
                col += 1
            }
            row += 1
            col = 0
        }
        
        return false
        
    }
    //    searches entire board for free spaces and returns a bool
    func areThereAnyFreeSpaces() -> Bool
    {
        var free_spaces = false
        var row = 0
        var col = 0
        while row < board.count
        {
            while col < board[0].count
            {
                //if we detect any free slots we return true
                if board[row][col] == nil
                {
                    free_spaces = true
                }
                col += 1
            }
            row += 1
            col = 0
        }
        return free_spaces
    }
    
    //    Randomly chooses to create a new '1' or a '2', and puts
    //    it in an open tile, if there is one.
    func spawn()
    {
        if areThereAnyFreeSpaces() == true
        {
            //found out where all the possible free spaces are
            var available_indexes : [[Int]] = []
            var row = 0
            var col = 0
            while row < board.count
            {
                while col < board[0].count
                {
                    //if we detect a free slot, add that idx to our tracker
                    if board[row][col] == nil
                    {
                        available_indexes.append([row,col])
                    }
                    col += 1
                }
                row += 1
                col = 0
            }
            //determine the value we will put once we choose a space
            var new_value = Int.random(in: 1...2, using: &seededGenerator)
            
            //choose the space
            var chosen_index = Int.random(in: 0...(available_indexes.count - 1), using: &seededGenerator)
            //find the row and col value of the chosen space and store it as a [row,col] array
            var chosen_row_chosen_col = available_indexes[chosen_index]
            board[chosen_row_chosen_col[0]][chosen_row_chosen_col[1]] = Tile(val: new_value, id: curr_id)
            curr_id += 1
            
            score += new_value
        }
        
    }
    //    checks if all game tiles filled AND that all movement is no longer possible a
    public func isGameDone() -> Bool
    {
        
        //           if no free spaces, make sure no movement can still occur
        if areThereAnyFreeSpaces() == false
        {
            var row = 0
            var col = 0
            //                check left right neighbors
            while row < board.count
            {
                //                    dont go out of bounds
                while col < board[0].count-1
                {
                    if let tile1 = board[row][col]
                    {
                        //if we detect any free slots we return true
                        if let tile2 = board[row][col+1]
                        {
                            if isPossible(tile1, tile2) == true
                            {
                                return false
                            }
                        }
                    }
                    col += 1
                }
                row += 1
                col = 0
            }
            //                check up down neighbors
            row = 0
            col = 0
            
            while  col < board[0].count
            {
                //                    dont go out of bounds
                while row < board.count-1
                {
                    if let tile1 = board[row][col]
                    {
                        //if we detect any free slots we return true
                        if let tile2 = board[row+1][col]
                        {
                            if isPossible(tile1, tile2) == true
                            {
                                return false
                            }
                        }
                    }
                    row += 1
                }
                col += 1
                row = 0
            }
            //                after checking all combinations, no possible movement found
            return true
        }
        //            if free spaces are available, it must be true that movement can occur, so
        //            the game will continue
        else
        {
            return false
        }
    }
}
struct Score: Hashable {
    var score: Int
    var time: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
    
    init(score: Int, time: Date) {
        self.score = score
        self.time = time
    }
}

//var score1 = Score(score: 300, time: Date())
//var score2 = Score(score: 400, time: Date())
//var scores : [Score] = []
//scores.append(score1)
//scores.append(score2)



public func rotate2DInts(input: [[Int]]) -> [[Int]]
{
    var len = input.count
    var output = Array(repeating: Array(repeating: 0, count: len), count: len)
    var row = 0
    var col = 0
    //transpose
    while row < len
    {
        col = 0
        while col < len
        {
            output[col][row] = input[row][col]
            col += 1
        }
        row += 1
    }
    //reverse
    row = 0
    while row < len
    {
        output[row] = output[row].reversed()
        row += 1
    }
    return output
}



//rotates a generic 2D matrix of size 4x4, works on strings, floats, etc..
public func rotate2D<T>(input: [[T]]) -> [[T]]
{
    var temp0 = [input[3][0], input[2][0], input[1][0], input[0][0]]
    var temp1 = [input[3][1], input[2][1], input[1][1], input[0][1]]
    var temp2 = [input[3][2], input[2][2], input[1][2], input[0][2]]
    var temp3 = [input[3][3], input[2][3], input[1][3], input[0][3]]
    
    var output = [temp0, temp1, temp2, temp3]
    return output
}

