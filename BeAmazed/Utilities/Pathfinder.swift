//
//  Pathfinder.swift
//  BeAmazed
//
//  Created by Veneta Todorova on 4.07.25.
//

struct Pathfinder {
    
    func findShortestPath(
        in mazeMap: [[Int]],
        startBlock: MazeBlock,
        endBlock: MazeBlock
    ) -> [MazePosition] {
        let rows = mazeMap.count
        let cols = mazeMap[0].count
        
        guard rows > 0, cols > 0 else { return [] }
        
        var visited = Set<MazePosition>()
        
        var queue = [(MazePosition, [MazePosition])]()
        
        for row in startBlock.minRow...startBlock.maxRow {
            for col in startBlock.minCol...startBlock.maxCol {
                let pos = MazePosition(row: row, col: col)
                if mazeMap[row][col] == 0 {
                    queue.append((pos, [pos]))
                    visited.insert(pos)
                }
            }
        }
        
        let directions = [(-1, 0), (0, 1), (1, 0), (0, -1)]
        
        while !queue.isEmpty {
            let (current, path) = queue.removeFirst()
            
            if endBlock.contains(current) {
                return path
            }
            
            for dir in directions {
                let newRow = current.row + dir.0
                let newCol = current.col + dir.1
                let neighbor = MazePosition(row: newRow, col: newCol)
                
                if newRow >= 0, newRow < rows,
                   newCol >= 0, newCol < cols,
                   mazeMap[newRow][newCol] == 0,
                   !visited.contains(neighbor) {
                    visited.insert(neighbor)
                    queue.append((neighbor, path + [neighbor]))
                }
            }
        }
        
        return []
    }
    
}
