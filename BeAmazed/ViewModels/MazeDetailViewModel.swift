//
//  MazeDetailViewModel.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 3.07.25.
//
import SwiftUI

@MainActor
class MazeDetailViewModel: ObservableObject {
    
    private let realmManager: RealmManager
    
    @Published var errorMessage: String? = nil
    
    @Published var displayImage: UIImage?
    
    init(realmManager: RealmManager = .shared) {
        self.realmManager = realmManager
    }
    
    func loadMazeAndFindPath(from url: URL) async {
        guard let image = await loadMazeImage(from: url) else {
            errorMessage = "Failed to load maze"
            return
        }
        
        displayImage = image
        
        let shortestPath: [MazePosition]
        let blockSize: Int
        
        if let (savedShortestPath, savedBlockSize) = realmManager.loadPathFromRealm(forImageUrl: url.absoluteString) {
            shortestPath = savedShortestPath
            blockSize = savedBlockSize
        } else {
            guard let maze = MazeExtractor().extractMaze(from: image) else {
                errorMessage = "Failed to extract maze"
                return
            }
            
            shortestPath = Pathfinder().findShortestPath(in: maze.mazeMap, startBlock: maze.startBlock, endBlock: maze.endBlock)
            blockSize = maze.blockSize
            
            realmManager.savePathToRealm(imageUrl: url.absoluteString, path: shortestPath, blockSize: blockSize)
        }
        
        displayImage = drawPathOverlay(on: image, path: shortestPath, blockSize: blockSize)
    }
    
    private func loadMazeImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            return image
        } catch {
            return nil
        }
    }
    
    func drawPathOverlay(on baseImage: UIImage, path: [MazePosition], blockSize: Int, pathColor: UIColor = .green) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: baseImage.size)
        
        let image = renderer.image { context in
            baseImage.draw(at: .zero)
            
            context.cgContext.setFillColor(pathColor.cgColor)
            
            for position in path {
                let rect = CGRect(
                    x: CGFloat(position.col * blockSize),
                    y: CGFloat(position.row * blockSize),
                    width: CGFloat(blockSize),
                    height: CGFloat(blockSize)
                )
                context.fill(rect)
            }
        }
        
        return image
    }
    
    
    //ONLY FOR DEBUG
    private func drawOverlay(on baseImage: UIImage, from map: [[Int]], blockSize: Int) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: baseImage.size)
        
        let image = renderer.image { context in
            //draw original maze
            baseImage.draw(at: .zero)
            
            //draw map
            context.cgContext.setLineWidth(1)
            for (rowIndex, row) in map.enumerated() {
                for (colIndex, value) in row.enumerated() {
                    let rect = CGRect(
                        x: CGFloat(colIndex * blockSize),
                        y: CGFloat(rowIndex * blockSize),
                        width: CGFloat(blockSize),
                        height: CGFloat(blockSize)
                    )
                    
                    if value == 1 {
                        UIColor.systemPink.setFill()
                        context.fill(rect)
                    } else {
                        UIColor.white.setFill()
                        context.fill(rect)
                    }
                }
            }
        }
        
        return image
    }
}
