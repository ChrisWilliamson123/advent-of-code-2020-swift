import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode)
    let forest = Forest(input)

    let slopesToCheck: [Coordinate] = [
        .init(x: 3, y: 1),
        .init(x: 1, y: 1),
        .init(x: 5, y: 1),
        .init(x: 7, y: 1),
        .init(x: 1, y: 2),
    ]

    let partOne = calculateNumberOfTreesHit(through: forest, usingSlope: slopesToCheck[0])
    print("Part 1: \(partOne)")

    let partTwo = slopesToCheck.map({ calculateNumberOfTreesHit(through: forest, usingSlope: $0) }).multiply()
    print("Part 2: \(partTwo)")
}

private func calculateNumberOfTreesHit(through forest: Forest, usingSlope slope: Coordinate) -> Int {
    var tobogganPosition = Coordinate(x: 0, y: 0)
    var treesHit = 0
    while tobogganPosition.y < forest.maxY {
        tobogganPosition = Coordinate(x: tobogganPosition.x + slope.x, y: tobogganPosition.y + slope.y)
        if forest.doesTreeExist(at: tobogganPosition) {
            treesHit += 1
        }
    }
    return treesHit
}

struct Forest {
    private let trees: Set<Coordinate>
    let maxY: Int
    private let maxX: Int

    init(_ forestMap: [String]) {
        var trees = Set<Coordinate>()

        let maxY = forestMap.count - 1
        let maxX = forestMap[0].count - 1
        for y in (0...maxY) {
            for x in (0...maxX) {
                if forestMap[y][x] == "#" {
                    trees.insert(Coordinate(x: x, y: y))
                }
            }

        }
        self.trees = trees
        self.maxY = maxY
        self.maxX = maxX
    }

    func doesTreeExist(at coordinate: Coordinate) -> Bool {
        let x = coordinate.x % (maxX + 1)
        return trees.contains(Coordinate(x: x, y: coordinate.y))
    }
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int
}

try main()
