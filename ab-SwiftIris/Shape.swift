//
//  Shape.swift
//  ab-SwiftIris
//
//  Created by Aaron Bradley on 2/14/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import SpriteKit

let NumOrientations: UInt32 = 4

enum Orientation: Int, Printable {
    case Zero = 0, Ninety, OneEighty, TwoSeventy

    var description: String {
        switch self {
        case .Zero:
            return "0"
        case .Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }

    // 1 - provide a method capable of returning the next orietnation when traveling either clockwise or counterclockwise
    static func random() -> Orientation {
        return Orientation(rawValue: Int(arc4random_uniform(NumOrientations)))!
    }

    static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}

let NumShapeTypes: UInt32 = 7

let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

class Shape: Hashable, Printable {

    // color the shape
    let color:BlockColor

    // the blocks comprising the shape
    var blocks = Array<Block>()
    // the current orientation of the shape
    var orientation: Orientation
    // the column and row representing the shape's anchor point
    var column, row:Int

    //required overrides
    // 1 - subclasses must override this property. Defines a computer dictionary
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }

    // 2 - and this one as well (see num 1 comment)
    var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [:]
    }

    //3 - computed property designed to return the bottom blocks of the shape at it current orientation.
    var bottomBlocks:Array<Block> {
        if let bottomBlocks = bottomBlocksForOrientations[orientation] {
            return bottomBlocks
        }
        return []
    }

    // Hashable
    var hashValue:Int {
        // 4 - iterate through entire blocks array, exclusively-or each block's hasValue together to create a single hasValue for the Shape they comprise
        return reduce(blocks, 0) { $0.hashValue ^ $1.hashValue }
    
    }
    // Printable
    var description: String {
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }

    init(column:Int, row:Int, color: BlockColor, orientation:Orientation) {
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlocks()
    }

    // 5 - convenience initializer to simplify the initialization process for users of the Shape class...assigns the given row and column values while generating a random color and a random orientation
    convenience init(column:Int, row:Int) {
        self.init(column:column, row:row, color:BlockColor.random(), orientation:Orientation.random())
    }

    // 1 - "final" function means it cannot be overriden by subclasses
    final func initializeBlocks() {

        // 2 - conditional assignment attempts to assign an array into blockRowColumnTranslations after extracting it from the computed dictionary property. If one is not found, the if block is not executed.
        if let blockRowColumnTranslations = blockRowColumnPositions[orientation] {
            for i in 0..<blockRowColumnTranslations.count {
                let blockRow = row + blockRowColumnTranslations[i].rowDiff
                let blockColumn = column + blockRowColumnTranslations[i].columnDiff
                let newBlock = Block(column: blockColumn, row: blockRow, color: color)
                blocks.append(newBlock)
            }
        }
    }

    // 1 - introduce enumerate operator to iterate through array object by defining an index variable - idx - as well as the contents of that index
    final func rotateBlocks(orientation: Orientation) {
        if let blockRowColumnTranslation:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] {

            for (idx, (columnDiff:Int, rowDiff:Int)) in enumerate(blockRowColumnTranslation) {
                blocks[idx].column = column + columnDiff
            }
        }
    }

    final func rotateClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: true)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }

    final func rotateCounterClockwise() {
        let newOrientation = Orientation.rotate(orientation, clockwise: false)
        rotateBlocks(newOrientation)
        orientation = newOrientation
    }

    final func lowerShapeByOneRow() {
        shiftBy(0, rows:1)
    }

    final func raiseShapeByOneRow() {
        shiftBy(0, rows: -1)
    }

    final func shiftRightByOneColumn() {
        shiftBy(1, rows: -1)
    }

    final func shiftLeftByOneColumn() {
        shiftBy(-1, rows: 0)
    }

    // 2 - indlude shiftBy method which will adjust each row and column by rows and columns respectively
    final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }

    // 3 - provide an absolute approach to position modification by setting the column and row properties before rotating the blocks to their current orientatiohn which cause an accurate realignment of all blocks relative to the new row and column properties
    final func moveTo(column: Int, row: Int) {
        self.column = column
        self.row = row
        rotateBlocks(orientation)
    }

    final class func random(startingColumn:Int, startingRow:Int) -> Shape {
        switch Int(arc4random_uniform(NumShapeTypes)) {

        // 4 - create a method to generate a random Tetromino shape...the subclasses naturally inherit initializers from the parent class created
        case 0:
            return SquareShape(column: startingColumn, row: startingRow)
        case 1:
            return LineShape(column: startingColumn, row: startingRow)
        case 2:
            return TShape(column: startingColumn, row: startingRow)
        case 3:
            return LShape(column: startingColumn, row: startingRow)
        case 4:
            return JShape(column: startingColumn, row: startingRow)
        case 5:
            return SShape(column: startingColumn, row: startingRow)
        default:
            return ZShape(column: startingColumn, row: startingRow)
        }
    }
}

func ==(lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}



































