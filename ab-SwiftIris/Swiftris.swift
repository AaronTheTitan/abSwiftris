//
//  Swiftris.swift
//  ab-SwiftIris
//
//  Created by Aaron Bradley on 3/8/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

// 1 - define total number of rows and columns on the game board, the location of where each piece starts and the location of where the new piece belongs

let NumColumns = 10
let NumRows = 20

let StartingColumn = 4
let StartingRow = 0

let PreviewColumn = 12
let PreviewRow = 1

class Swiftris {
    var blockArray:Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?

    init() {
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
    }

    func beginGame() {
        if (nextShape == nil) {
            nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        }
    }

// 2 - method assigns nextShape, preview shape as fallingShape. fallingShape is the moving Tetromino. newShape() then creates a new preview shape before moving fallingShape to the starting row and column. Method returns a tuple of optional Shape objects.
    
    func newShape() -> (fallingShape:Shape?, nextShape:Shape?) {
        fallingShape = nextShape
        nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(StartingColumn, row: StartingRow)
        return (fallingShape, nextShape)
    }
}