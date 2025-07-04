//
//  MazeStorage.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//

protocol MazeStorage {
    func saveShortestPath(imageUrl: String, path: [MazePosition], blockSize: Int)
    
    func loadShortestPath(forImageUrl url: String) -> (shortestPath: [MazePosition], blockSize: Int)?
}
