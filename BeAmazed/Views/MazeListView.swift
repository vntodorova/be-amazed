//
//  ContentView.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 3.07.25.
//

import SwiftUI

import SwiftUI

struct MazeListView: View {
    @StateObject private var viewModel = MazeListViewModel()
    
    var body: some View {
        NavigationStack {
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(viewModel.mazes, id: \.url) { maze in
                    NavigationLink(destination: MazeDetailView(maze: maze)) {
                        MazeRowView(maze: maze)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchMazes()
            }
        }
    }
}

#Preview {
    MazeListView()
}
