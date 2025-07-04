//
//  MazeDetailView.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 3.07.25.
//
import SwiftUI

struct MazeDetailView: View {
    @StateObject private var viewModel = MazeDetailViewModel(storage: RealmManager())
    
    let maze: MazeData
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        Group {
            switch (viewModel.errorMessage, viewModel.displayImage) {
            case let (error?, _):
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            case (nil, let image?):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: UIScreen.main.bounds.width)
                    .scaleEffect(scale)
                    .offset(offset)
                    .modifier(ZoomDragGesture(scale: $scale, lastScale: $lastScale, offset: $offset, lastOffset: $lastOffset))
                    .animation(.easeInOut, value: scale)
            case (nil, nil):
                ProgressView()
            }
        }
        .navigationTitle(maze.name)
        .onAppear {
            Task {
                await viewModel.loadMazeAndFindPath(from: maze.url)
            }
        }
    }
}
