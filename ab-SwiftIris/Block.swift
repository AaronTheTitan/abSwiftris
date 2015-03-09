//
//  Block.swift
//  ab-SwiftIris
//
//  Created by Aaron Bradley on 2/13/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import SpriteKit

let NumberOfColors: UInt32 = 6

enum BlockColor: Int, Printable {
    case Blue = 0, Orange, Purple, Red, Teal, Yellow

    var spriteName: String {
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
        }
    }

    var description: String {
        return self.spriteName
    }

    static func random() -> BlockColor {
        return BlockColor(rawValue:Int(arc4random_uniform(NumberOfColors)))!
    }
}


// 1 - declare block as a class that implements the Printable and Hashable protocols
class Block: Hashable, Printable {

    // 2 - define color property as a constant. block piece shouldn't be able to change colors mid-game
    let color: BlockColor

    // 3 - properties for column and row...represents the location of the block on game board
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?

    // 4 - shortcut for recovering the file name of the sprite to be used with displaying this block
    var spriteName: String {
        return color.spriteName
    }

    // 5 - implement hasValue calculated property..required in order to support the Hasable protocol...return exlusive-or of row and column properties to generate a unique integer for each Block
    var hashValue: Int {
        return self.column ^ self.row
    }

    // 6 - implement description in order to comply with the Printable protocol. Printables can be placed in the middle of a string via interpolation. I.E a blue block at row 3, column 8 will result in "blue: [8, 3]"
    var description: String {
        return "\(color): [\(column), \(row)]"
    }

    init(column:Int, row:Int, color:BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
}

// 7 - create a custom operator == whenc omparing one Block with another. Returns 'true' only if both Blocks are in the same location and of the same color. Required in order to support the Hasable protocol.
func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}















