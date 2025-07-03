//
//  MazeDetailViewModel.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 3.07.25.
//
import SwiftUI

struct Maze {
    let mazeMap: [[Int]]
    let startBlock: MazeBlock
    let endBlock: MazeBlock
    let blockSize: Int
}

struct MazePosition: Hashable {
    let row: Int
    let col: Int
}

struct MazeBlock {
    let minRow: Int
    let maxRow: Int
    let minCol: Int
    let maxCol: Int
    
    func contains(_ pos: MazePosition) -> Bool {
        return pos.row >= minRow && pos.row <= maxRow && pos.col >= minCol && pos.col <= maxCol
    }
}

@MainActor
class MazeDetailViewModel: ObservableObject {
    
    @Published var errorMessage: String? = nil
    
    @Published var displayImage: UIImage?
    
    func loadMazeAndFindPath(from url: URL) async {
        guard let image = await loadMazeImage(from: url) else {
            errorMessage = "Failed to load maze"
            return
        }
        
        displayImage = image
        
        guard let maze = extractMaze(from: image) else {
            errorMessage = "Failed to extract maze"
            return
        }
        
        let shortestPath = findShortestPath(in: maze.mazeMap, startBlock: maze.startBlock, endBlock: maze.endBlock)
        
        displayImage = drawPathOverlay(on: image, path: shortestPath, blockSize: maze.blockSize)
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
    
    private func extractMaze(from image: UIImage) -> Maze? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let pixelData = getPixelData(from: cgImage)
        
        guard
            let blueRectBounds = detectDotBoundingBox(pixelData: pixelData, width: width, height: height, targetColor: Constants.blueColor),
            let redRectBounds = detectDotBoundingBox(pixelData: pixelData, width: width, height: height, targetColor: Constants.redColor)
        else {
            return nil
        }
        
        let mazePathWidth = min(blueRectBounds.width, blueRectBounds.height, redRectBounds.width, redRectBounds.height)
        
        let blockSize = (mazePathWidth / 2 <= 1) ? 1 : Int(mazePathWidth) / 2
        
        let mazeMap = getMazeMap(from: cgImage, blockSize: blockSize, pixelData: pixelData)
        
        let mazeRowsCount = mazeMap.count
        let mazeColsCount = mazeMap[0].count
                
        let blueMazeBlock = mapBoundingBoxToMazeGrid(boundingBox: blueRectBounds, blockSize: blockSize, mazeRows: mazeRowsCount, mazeCols: mazeColsCount)
        let redMazeBlock = mapBoundingBoxToMazeGrid(boundingBox: redRectBounds, blockSize: blockSize, mazeRows: mazeRowsCount, mazeCols: mazeColsCount)

        return Maze(mazeMap: mazeMap, startBlock: blueMazeBlock, endBlock: redMazeBlock, blockSize: blockSize)
    }
    
    func detectDotBoundingBox(pixelData: [UInt8], width: Int, height: Int, targetColor: (r: UInt8, g: UInt8, b: UInt8)) -> CGRect? {
        var minX = width
        var minY = height
        var maxX = 0
        var maxY = 0
        
        var foundPixel = false
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * Constants.bytesPerPixel
                
                if colorMatches(at: pixelIndex, pixelData: pixelData, targetColor: targetColor) {
                    foundPixel = true
                    if x < minX { minX = x }
                    if x > maxX { maxX = x }
                    if y < minY { minY = y }
                    if y > maxY { maxY = y }
                }
            }
        }
        
        guard foundPixel else { return nil }
        
        return CGRect(x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1)
    }
    
    private func colorMatches(at index: Int, pixelData: [UInt8], targetColor: (r: UInt8, g: UInt8, b: UInt8)) -> Bool {
        let r = pixelData[index]
        let g = pixelData[index + 1]
        let b = pixelData[index + 2]
        
        return abs(Int(r) - Int(targetColor.r)) <= 0 &&
        abs(Int(g) - Int(targetColor.g)) <= 0 &&
        abs(Int(b) - Int(targetColor.b)) <= 0
    }
    
    private func getMazeMap(from cgImage: CGImage, blockSize: Int, pixelData: [UInt8]) -> [[Int]] {
        let width = cgImage.width
        let height = cgImage.height
        
        let gridWidth = width / blockSize
        let gridHeight = height / blockSize
        
        var mazeMap = Array(repeating: Array(repeating: 0, count: gridWidth), count: gridHeight)
        
        for gridY in 0..<gridHeight {
            for gridX in 0..<gridWidth {
                var blockHasBlackPixel = false
                
                let startX = gridX * blockSize
                let startY = gridY * blockSize
                
                outerLoop: for y in startY..<(startY + blockSize) {
                    for x in startX..<(startX + blockSize) {
                        let pixelIndex = (y * width + x) * Constants.bytesPerPixel
                        let r = pixelData[pixelIndex]
                        let g = pixelData[pixelIndex + 1]
                        let b = pixelData[pixelIndex + 2]
                        let threshold: UInt8 = 50
                        if r < threshold && g < threshold && b < threshold {
                            blockHasBlackPixel = true
                            break outerLoop
                        }
                    }
                }
                
                mazeMap[gridY][gridX] = blockHasBlackPixel ? 1 : 0
            }
        }
        
        return mazeMap
    }
    
    private func getPixelData(from image: CGImage) -> [UInt8] {
        let width = image.width
        let height = image.height
        let bytesPerRow = Constants.bytesPerPixel * width
        
        var pixelData = [UInt8](repeating: 0, count: width * height * Constants.bytesPerPixel)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: width,
                                height: height,
                                bitsPerComponent: Constants.bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        return pixelData
    }
    
    func mapBoundingBoxToMazeGrid(
        boundingBox: CGRect,
        blockSize: Int,
        mazeRows: Int,
        mazeCols: Int
    ) -> MazeBlock {
        let minCol = max(0, Int(boundingBox.minX) / blockSize)
        let maxCol = min(mazeCols - 1, Int(boundingBox.maxX) / blockSize)
        
        let minRow = max(0, Int(boundingBox.minY) / blockSize)
        let maxRow = min(mazeRows - 1, Int(boundingBox.maxY) / blockSize)
        
        return MazeBlock(minRow: minRow, maxRow: maxRow, minCol: minCol, maxCol: maxCol)
    }
    
    func findShortestPath(
        in mazeMap: [[Int]],
        startBlock: MazeBlock,
        endBlock: MazeBlock
    ) -> [MazePosition] {
        let rows = mazeMap.count
        let cols = mazeMap[0].count
        
        guard rows > 0, cols > 0 else { return [] }
        
        var visited = Set<MazePosition>()
        
        var queue = [(MazePosition, [MazePosition])]()
        
        for row in startBlock.minRow...startBlock.maxRow {
            for col in startBlock.minCol...startBlock.maxCol {
                let pos = MazePosition(row: row, col: col)
                if mazeMap[row][col] == 0 {
                    queue.append((pos, [pos]))
                    visited.insert(pos)
                }
            }
        }
        
        let directions = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        
        while !queue.isEmpty {
            let (current, path) = queue.removeFirst()
            
            if endBlock.contains(current) {
                return path
            }
            
            for dir in directions {
                let newRow = current.row + dir.0
                let newCol = current.col + dir.1
                let neighbor = MazePosition(row: newRow, col: newCol)
                
                if newRow >= 0, newRow < rows,
                   newCol >= 0, newCol < cols,
                   mazeMap[newRow][newCol] == 0,
                   !visited.contains(neighbor) {
                    visited.insert(neighbor)
                    queue.append((neighbor, path + [neighbor]))
                }
            }
        }
        
        return []
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
