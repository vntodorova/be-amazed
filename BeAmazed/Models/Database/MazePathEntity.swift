//
//  MazePathEntity.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//
import RealmSwift

class MazePathEntity: Object {
    @Persisted(primaryKey: true) var imageURL: String
    @Persisted var path: List<MazePositionEntity>
    @Persisted var blockSize: Int
    
    convenience init(url: String, path: [MazePosition], blockSize: Int) {
        self.init()
        self.blockSize = blockSize
        let mazePositionEntityList = path.map { position in
            MazePositionEntity(row: position.row, col: position.col)
            }
        self.imageURL = url
        self.path.append(objectsIn: mazePositionEntityList)
    }
}

extension MazePathEntity {
    func toDomain() -> ([MazePosition], Int) {
        let positions = Array(path.map { MazePosition(row: $0.row, col: $0.col) })
        return (positions, blockSize)
    }
}
