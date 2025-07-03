//
//  MazeRowView.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 3.07.25.
//

import SwiftUI

struct MazeRowView: View {
    
    let maze: MazeData
    
    var body: some View {
        HStack {
            AsyncImage(url: maze.url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 60, height: 60)
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                    
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                        .frame(width: 60, height: 60)
                    
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading) {
                Text(maze.name)
                    .font(.headline)
                Text(maze.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
