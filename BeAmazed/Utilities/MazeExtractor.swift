//
//  MazeExtractor.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//
import SwiftUI

struct MazeExtractor {
    
    func extractMaze(from image: UIImage) -> Maze? {
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
    
    private func detectDotBoundingBox(pixelData: [UInt8], width: Int, height: Int, targetColor: (r: UInt8, g: UInt8, b: UInt8)) -> CGRect? {
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
    
    private func mapBoundingBoxToMazeGrid(
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
    
}
