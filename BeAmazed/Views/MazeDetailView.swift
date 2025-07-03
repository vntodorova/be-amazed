//
//  MazeDetailView.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 3.07.25.
//
import SwiftUI

struct MazeDetailView: View {
    @StateObject private var viewModel = MazeDetailViewModel()
    
    let maze: Maze
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        AsyncImage(url: maze.url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: UIScreen.main.bounds.width)
                    .scaleEffect(scale)
                                .offset(offset)
                                .gesture(
                                    SimultaneousGesture(
                                        MagnificationGesture()
                                            .onChanged { value in
                                                let delta = value / lastScale
                                                scale *= delta
                                                lastScale = value
                                                
                                                if (scale <= 1) {
                                                    scale = 1
                                                    offset = .zero
                                                }
                                            }
                                            .onEnded { _ in
                                                lastScale = scale
                                            },
                                        DragGesture()
                                            .onChanged { value in
                                                offset = CGSize(width: lastOffset.width + value.translation.width,
                                                                height: lastOffset.height + value.translation.height)
                                            }
                                            .onEnded { _ in
                                                lastOffset = offset
                                            }
                                    )
                                )
                                .animation(.easeInOut, value: scale)
                
            case .failure:
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
                
            @unknown default:
                EmptyView()
            }
        }
        .navigationTitle(maze.name)
    }
}
