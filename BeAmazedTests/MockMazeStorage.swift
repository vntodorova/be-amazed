//
//  MockMazeStorage.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//
@testable import BeAmazed

final class MockMazeStorage: MazeStorage {
    var savedPaths: [String: ([MazePosition], Int)] = [:]
    
    func loadShortestPath(forImageUrl url: String) -> (shortestPath: [MazePosition], blockSize: Int)? {
        return savedPaths[url]
    }

    func saveShortestPath(imageUrl: String, path: [MazePosition], blockSize: Int) {
        savedPaths[imageUrl] = (path, blockSize)
    }
}
