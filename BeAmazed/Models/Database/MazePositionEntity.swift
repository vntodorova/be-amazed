//
//  MazePositionEntity.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//
import RealmSwift

class MazePositionEntity: Object {
    @Persisted var row: Int
    @Persisted var col: Int
    
    convenience init(row: Int, col: Int) {
        self.init()
        self.row = row
        self.col = col
    }
}
