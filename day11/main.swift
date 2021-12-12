import Foundation

let EMPTY: Character = "L"
let OCCUPIED: Character = "#"
let FLOOR: Character = "."

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode)

    var grid = input.map({ [Character]($0) })

    while true {
        var newState = grid
        for y in 0..<grid.count {
            for x in 0..<grid[y].count {
                let current = grid[y][x]
                let coordinate = Coordinate(x: x, y: y)
                let adjacents = coordinate.adjacents.filter({ ($0.x >= 0 && $0.x < grid[y].count) && ($0.y >= 0 && $0.y < grid.count) })
                let occupiedAdjacents = adjacents.filter({ grid[$0.y][$0.x] == OCCUPIED })

                if current == EMPTY && occupiedAdjacents.count == 0 {
                    newState[y][x] = OCCUPIED
                } else if current == OCCUPIED && occupiedAdjacents.count >= 4 {
                    newState[y][x] = EMPTY
                }
            }
        }
        if newState == grid {
            let occupiedSeatCount = grid.flatMap({ $0 }).filter({ $0 == OCCUPIED }).count
            print(occupiedSeatCount)
            break
        }
        grid = newState
    }

    // Part 2
    grid = input.map({ [Character]($0) })

    while true {
        var newState = grid
        for y in 0..<grid.count {
            for x in 0..<grid[y].count {
                let current = grid[y][x]
                let coordinate = Coordinate(x: x, y: y)
                let visibleSeats = [(0, 1), (1, 1), (1, 0), (1, -1), (0, -1), (-1, -1), (-1, 0), (-1, 1)].map({ Coordinate(x: $0.0, y: $0.1) }).compactMap({ getFirstVisibleSeat(from: coordinate, in: grid, direction: $0) })
                let occupiedVisibles = visibleSeats.filter({ grid[$0.y][$0.x] == OCCUPIED })

                if current == EMPTY && occupiedVisibles.count == 0 {
                    newState[y][x] = OCCUPIED
                } else if current == OCCUPIED && occupiedVisibles.count >= 5 {
                    newState[y][x] = EMPTY
                }
            }
        }
        if newState == grid {
            let occupiedSeatCount = grid.flatMap({ $0 }).filter({ $0 == OCCUPIED }).count
            print(occupiedSeatCount)
            break
        }
        grid = newState
    }
}

private func printLayout(_ layout: [[Character]]) {
    for line in layout {
        print(line.map({ String($0) }).joined())
    }
}

private func getFirstVisibleSeat(from coordinate: Coordinate, in graph: [[Character]], direction: Coordinate) -> Coordinate? {
    var currentCoord = Coordinate(x: coordinate.x + direction.x, y: coordinate.y + direction.y)

    while (currentCoord.x >= 0 && currentCoord.x < graph[0].count) && (currentCoord.y >= 0 && currentCoord.y < graph.count) {
        let currentCharacter = graph[currentCoord.y][currentCoord.x]
        if currentCharacter == EMPTY || currentCharacter == OCCUPIED {
            return currentCoord
        }

        currentCoord = Coordinate(x: currentCoord.x + direction.x, y: currentCoord.y + direction.y)
    }

    return nil
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int

    var adjacents: [Coordinate] {
        var adjacents: [Coordinate] = []
        for x in x-1...x+1 {
            for y in y-1...y+1  {
                if x == self.x && y == self.y { continue }
                adjacents.append(Coordinate(x: x, y: y))
            }
        }
        return adjacents
    }
}

try main()
