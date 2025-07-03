//
//  MazeDetailViewModel.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 3.07.25.
//
import SwiftUI

@MainActor
class MazeDetailViewModel: ObservableObject {
    
    @Published var errorMessage: String? = nil
    
    @Published var displayImage: UIImage?
    
    func loadMazeAndFindPath(from url: URL) async {
        guard let image = await loadMaze(from: url) else {
            return
        }
        
        displayImage = image
        
        extractMaze(from: image)
        
    }
    
    private func loadMaze(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                errorMessage = "Failed to decode image."
                return nil
            }
            
            return image
        } catch {
            errorMessage = "Image couldn't download: \(error.localizedDescription)"
            return nil
        }
    }
    
    private func extractMaze(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            errorMessage = "Failed to decode image."
            return
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let pixelData = getPixelData(from: cgImage)
        
        guard
            let blueRectBounds = detectDotBoundingBox(pixelData: pixelData, width: width, height: height, targetColor: Constants.blueColor),
            let redRectBounds = detectDotBoundingBox(pixelData: pixelData, width: width, height: height, targetColor: Constants.redColor)
        else {
            errorMessage = "No start/finish detected."
            return
        }
        
        let mazePathWidth = min(blueRectBounds.width, blueRectBounds.height, redRectBounds.width, redRectBounds.height)
        
        let blockSize = (mazePathWidth / 3 <= 1) ? 1 : Int(mazePathWidth) / 2
        
        let pixelBlockMap = getPixelMap(from: cgImage, blockSize: blockSize, pixelData: pixelData)
        
        displayImage = drawOverlay(on: image, from: pixelBlockMap, blockSize: blockSize)
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
    
    private func getPixelMap(from cgImage: CGImage, blockSize: Int, pixelData: [UInt8]) -> [[Int]] {
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
