//
//  MazeExtractionTests.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//


import XCTest
@testable import BeAmazed

final class MazeExtractionTests: XCTestCase {

    func testExtractMaze_validMaze_returnsCorrectMaze() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "valid-maze", withExtension: "png"),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            XCTFail("Failed to load test maze image")
            return
        }

        guard let maze = MazeExtractor().extractMaze(from: image) else {
            XCTFail("Maze extraction failed")
            return
        }

        XCTAssertEqual(maze.blockSize, MazeTestData.mazeBlockSizeValidMaze)
        XCTAssertEqual(maze.mazeMap.count, MazeTestData.validMazeMap.count)
        XCTAssertEqual(maze.mazeMap[0].count, MazeTestData.validMazeMap[0].count)
        XCTAssertEqual(maze.startBlock.contains(MazePosition(row: 18, col: 0)), true)
        XCTAssertEqual(maze.startBlock.contains(MazePosition(row: 20, col: 2)), true)
        XCTAssertEqual(maze.endBlock.contains(MazePosition(row: 18, col: 10)), true)
        XCTAssertEqual(maze.endBlock.contains(MazePosition(row: 20, col: 12)), true)
        
        let expectedMap = MazeTestData.validMazeMap
        XCTAssertEqual(maze.mazeMap, expectedMap)
    }
    
    func testExtractMaze_invalidMaze_returnsEmpty() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "invalid-maze", withExtension: "jpeg"),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            XCTFail("Failed to load test maze image")
            return
        }

        let maze = MazeExtractor().extractMaze(from: image)

        XCTAssertNil(maze, "Maze should be nil for invalid image input")
    }
}
