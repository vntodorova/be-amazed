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
    
    @Published var errorMessage: String? = nil
    
    func fetchMazes() async {
        guard let url = URL(string: mazesURL), url.scheme != nil else {
            errorMessage = "Invalid URL"
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                errorMessage = "Server error: \((response as? HTTPURLResponse)?.statusCode ?? 0)"
                return
            }
            
            let decoded = try JSONDecoder().decode(MazeResponse.self, from: data)
            
            self.mazes = decoded.list
        } catch {
            errorMessage = "Failed to fetch: \(error.localizedDescription)"
        }
    }
}
