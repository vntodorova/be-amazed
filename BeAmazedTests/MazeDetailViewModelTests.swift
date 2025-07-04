//
//  MazeDetailViewModelTests.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//
import XCTest
@testable import BeAmazed

final class MazeDetailViewModelTests: XCTestCase {
    
    func testPathSaving_withValidImage_setsImageNoErrorMessage() async {
        let mockStorage = MockMazeStorage()
        let viewModel = await MazeDetailViewModel(storage: mockStorage)

        guard let validImageUrl = Bundle(for: Self.self).url(forResource: "valid-maze", withExtension: "png") else {
            XCTFail("Failed to get url for image.")
            return
        }

        await viewModel.loadMazeAndFindPath(from: validImageUrl)
        
        let savedPath = mockStorage.loadShortestPath(forImageUrl: validImageUrl.absoluteString)

        Task { @MainActor in
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertNotNil(viewModel.displayImage)
            XCTAssertNotNil(savedPath)
        }
    }
    
    func testPathLoading_withInvalidImage_setsImageNoErrorMessage() async {
        let mockStorage = MockMazeStorage()
        let viewModel = await MazeDetailViewModel(storage: mockStorage)
        
        guard let invalidImageURL = Bundle(for: Self.self).url(forResource: "invalid-maze", withExtension: "jpeg") else {
            XCTFail("Failed to get url for image.")
            return
        }
        
        mockStorage.saveShortestPath(imageUrl: invalidImageURL.absoluteString, path: [MazePosition(row: 0, col: 0), MazePosition(row: 1, col: 0)], blockSize: 1)
        
        await viewModel.loadMazeAndFindPath(from: invalidImageURL)

        Task { @MainActor in
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertNotNil(viewModel.displayImage)
        }
    }
    
    func testLoadMazeAndFindPath_withInvalidUrl_setsErrorMessageNoImage() async {
        let mockStorage = MockMazeStorage()
        let viewModel = await MazeDetailViewModel(storage: mockStorage)

        let testURL = URL(string: "https://invalid.image/url")!

        await viewModel.loadMazeAndFindPath(from: testURL)

        Task { @MainActor in
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertNil(viewModel.displayImage)
        }
    }
    
    func testLoadMazeAndFindPath_withInvalidImage_setsErrorMessageWithImage() async {
        let mockStorage = MockMazeStorage()
        let viewModel = await MazeDetailViewModel(storage: mockStorage)

        guard let invalidImageURL = Bundle(for: Self.self).url(forResource: "invalid-maze", withExtension: "jpeg") else {
            XCTFail("Failed to get url for image.")
            return
        }
        
        await viewModel.loadMazeAndFindPath(from: invalidImageURL)

        Task { @MainActor in
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertNotNil(viewModel.displayImage)
        }
    }
    
    func testLoadMazeAndFindPath_withValidUrl_setsImageNoErrorMessage() async {
        let mockStorage = MockMazeStorage()
        let viewModel = await MazeDetailViewModel(storage: mockStorage)

        guard let validImageUrl = Bundle(for: Self.self).url(forResource: "valid-maze", withExtension: "png") else {
            XCTFail("Failed to get url for image.")
            return
        }

        await viewModel.loadMazeAndFindPath(from: validImageUrl)

        Task { @MainActor in
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertNotNil(viewModel.displayImage)
        }
    }

}
