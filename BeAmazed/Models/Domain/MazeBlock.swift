//
//  MazeBlock.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//
import Foundation

struct MazeBlock {
    let minRow: Int
    let maxRow: Int
    let minCol: Int
    let maxCol: Int
    
    func contains(_ pos: MazePosition) -> Bool {
        return pos.row >= minRow && pos.row <= maxRow && pos.col >= minCol && pos.col <= maxCol
    }
}
