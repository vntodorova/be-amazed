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
    
    func savePathToRealm(imageUrl: String, path: [MazePosition], blockSize: Int) {
        let realm = try! Realm()

        let mazePathEntity = MazePathEntity(url: imageUrl, path: path, blockSize: blockSize)

        try! realm.write {
            realm.add(mazePathEntity, update: .modified)
        }
    }
    
    func loadPathFromRealm(forImageUrl url: String) -> (positions: [MazePosition], blockSize: Int)? {
        let realm = try! Realm()

        guard let mazePathEntity = realm.object(ofType: MazePathEntity.self, forPrimaryKey: url) else {
            return nil
        }

        return mazePathEntity.toDomain()
    }
}
