//
//  MazeTestData.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//

import Foundation
@testable import BeAmazed

enum MazeTestData {
    static let validMazeMap: [[Int]] = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
        [1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1],
        [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1],
        [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1],
        [1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1],
        [1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1],
        [1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1],
        [1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    ]
    
    static let shortestPathForValidMaze: [MazePosition] = [
        MazePosition(row: 18, col: 1),
        MazePosition(row: 17, col: 1),
        MazePosition(row: 16, col: 1),
        MazePosition(row: 15, col: 1),
        MazePosition(row: 14, col: 1),
        MazePosition(row: 13, col: 1),
        MazePosition(row: 13, col: 2),
        MazePosition(row: 13, col: 3),
        MazePosition(row: 12, col: 3),
        MazePosition(row: 11, col: 3),
        MazePosition(row: 11, col: 2),
        MazePosition(row: 11, col: 1),
        MazePosition(row: 10, col: 1),
        MazePosition(row: 9,  col: 1),
        MazePosition(row: 9,  col: 2),
        MazePosition(row: 9,  col: 3),
        MazePosition(row: 9,  col: 4),
        MazePosition(row: 9,  col: 5),
        MazePosition(row: 8,  col: 5),
        MazePosition(row: 7,  col: 5),
        MazePosition(row: 7,  col: 6),
        MazePosition(row: 7,  col: 7),
        MazePosition(row: 7,  col: 8),
        MazePosition(row: 7,  col: 9),
        MazePosition(row: 6,  col: 9),
        MazePosition(row: 5,  col: 9),
        MazePosition(row: 5,  col: 10),
        MazePosition(row: 5,  col: 11),
        MazePosition(row: 6,  col: 11),
        MazePosition(row: 7,  col: 11),
        MazePosition(row: 7,  col: 12),
        MazePosition(row: 7,  col: 13),
        MazePosition(row: 8,  col: 13),
        MazePosition(row: 9,  col: 13),
        MazePosition(row: 9,  col: 14),
        MazePosition(row: 9,  col: 15),
        MazePosition(row: 10, col: 15),
        MazePosition(row: 11, col: 15),
        MazePosition(row: 11, col: 16),
        MazePosition(row: 11, col: 17),
        MazePosition(row: 11, col: 18),
        MazePosition(row: 11, col: 19),
        MazePosition(row: 12, col: 19),
        MazePosition(row: 13, col: 19),
        MazePosition(row: 13, col: 18),
        MazePosition(row: 13, col: 17),
        MazePosition(row: 14, col: 17),
        MazePosition(row: 15, col: 17),
        MazePosition(row: 15, col: 18),
        MazePosition(row: 15, col: 19),
        MazePosition(row: 16, col: 19),
        MazePosition(row: 17, col: 19),
        MazePosition(row: 18, col: 19),
        MazePosition(row: 19, col: 19),
        MazePosition(row: 19, col: 18),
        MazePosition(row: 19, col: 17),
        MazePosition(row: 19, col: 16),
        MazePosition(row: 19, col: 15),
        MazePosition(row: 19, col: 14),
        MazePosition(row: 19, col: 13),
        MazePosition(row: 19, col: 12),
    ]


    static let noPathMaze: [[Int]] = [
        [0, 1],
        [1, 0]
    ]
    static let startBlockNoPathMaze = MazeBlock(minRow: 0, maxRow: 0, minCol: 0, maxCol: 0)
    static let endBlockNoPathMaze = MazeBlock(minRow: 1, maxRow: 1, minCol: 1, maxCol: 1)

    static let startBlockValidMaze = MazeBlock(minRow: 18, maxRow: 20, minCol: 0, maxCol: 2)
    static let endBlockValidMaze = MazeBlock(minRow: 18, maxRow: 20, minCol: 10, maxCol: 12)
    static let mazeBlockSizeValidMaze = 21
    
    static let startBlockNoPath = MazeBlock(minRow: 0, maxRow: 0, minCol: 0, maxCol: 0)
    static let endBlockNoPath = MazeBlock(minRow: 1, maxRow: 1, minCol: 1, maxCol: 1)
}
