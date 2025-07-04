//
//  RealmManager.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private let realm = try! Realm()
}

extension RealmManager : MazeStorage {
    
    func saveShortestPath(imageUrl: String, path: [MazePosition], blockSize: Int) {
        let realm = try! Realm()

        let mazePathEntity = MazePathEntity(url: imageUrl, path: path, blockSize: blockSize)

        try! realm.write {
            realm.add(mazePathEntity, update: .modified)
        }
    }
    
    func loadShortestPath(forImageUrl url: String) -> (shortestPath: [MazePosition], blockSize: Int)? {
        let realm = try! Realm()

        guard let mazePathEntity = realm.object(ofType: MazePathEntity.self, forPrimaryKey: url) else {
            return nil
        }

        return mazePathEntity.toDomain()
    }
    
}
