//
//  MazeListViewModel.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 3.07.25.
//

import Foundation

private let mazesURL = "https://downloads-secured.bluebeam.com/homework/mazes"

@MainActor
class MazeListViewModel: ObservableObject {
    
    @Published var mazes: [Maze] = []
        
    func fetchMazes() async {
        guard let url = URL(string: mazesURL), url.scheme != nil else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoded = try JSONDecoder().decode(MazeResponse.self, from: data)
            
            self.mazes = decoded.list
            
        } catch {
            print("Failed to fetch: \(error.localizedDescription)")
        }
    }
}
