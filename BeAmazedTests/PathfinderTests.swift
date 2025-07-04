//
//  MazePosition.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//
import XCTest
@testable import BeAmazed

final class PathfinderTests: XCTestCase {
    
    func testFindShortestPath_simpleMaze_returnsCorrectPath() {
        let mazeMap = MazeTestData.validMazeMap
        
        let pathfinder = Pathfinder()
        
        let path = pathfinder.findShortestPath(in: mazeMap, startBlock: MazeTestData.startBlockValidMaze, endBlock: MazeTestData.endBlockValidMaze)
                
        XCTAssertEqual(path, MazeTestData.shortestPathForValidMaze)
    }
    
    func testFindShortestPath_noPath_returnsEmpty() {
        let mazeMap = MazeTestData.noPathMaze
        
        let pathfinder = Pathfinder()
        
        let path = pathfinder.findShortestPath(in: mazeMap, startBlock: MazeTestData.startBlockNoPathMaze, endBlock: MazeTestData.endBlockNoPathMaze)
        
        XCTAssertTrue(path.isEmpty)
    }
}
