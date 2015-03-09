//
//  SquareShape.swift
//  ab-SwiftIris
//
//  Created by Aaron Bradley on 2/14/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

class SquareShape:Shape {

/*
// 1 - position 0 is the row/column indicator for the shape
        |0|1|
        |2|3|
*/
    // square shape won't rotate

    // 2 - override the blcokRowColumnPositions computed property to provide a full dictionary of tuple arrays...each index of the arrays represents one of the four blocks ordered from block 0 to block 3.
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.OneEighty: [(0,0), (1, 0), (0, 1), (1, 1)],
            Orientation.Ninety: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.TwoSeventy: [(0, 0), (1, 0), (0, 1), (1, 1)]
        ]
    }

    // 3 - similar override as #2, provides a dictionary of bottom block arrays
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.Zero:       [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.OneEighty:  [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Ninety:     [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
}

