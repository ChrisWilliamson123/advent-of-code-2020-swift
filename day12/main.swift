import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode)
    
    var ship = Ship(input)
    ship.navigate()
    print("Part 1:", abs(ship.currentPosition.x) + abs(ship.currentPosition.y))

    ship = Ship(input)
    ship.navigateWithWaypoint()
    print("Part 2:", abs(ship.currentPosition.x) + abs(ship.currentPosition.y))
}

class Ship {
    typealias Instruction = (action: String, value: Int)
    var direction: Coordinate {
        directions[0]
    }
    var directions: [Coordinate] = [Coordinate(1, 0), Coordinate(0, -1), Coordinate(-1, 0), Coordinate(0, 1)]
    var currentPosition: Coordinate = Coordinate(0, 0)
    var relativeWaypointPosition: Coordinate = Coordinate(10, 1)
    let instructions: [Instruction]

    init(_ instructions: [String]) {
        self.instructions = instructions.map({
            let regex = Regex("(\\w)(\\d+)")
            let matches = regex.getMatches(in: $0)
            return (matches[0], Int(matches[1])!)
        })
    }

    func navigate() {
        for i in instructions {
            switch i.action {
                case "N", "S", "E", "W":
                    let modifier = [
                        "N": Coordinate(0, 1),
                        "S": Coordinate(0, -1),
                        "E": Coordinate(1, 0),
                        "W": Coordinate(-1, 0),
                    ][i.action]!
                    currentPosition = Coordinate(currentPosition.x + (modifier.x * i.value), currentPosition.y + (modifier.y * i.value))
                case "L":
                    let toRotate = i.value / 90
                    directions.rotateRight(positions: toRotate)
                case "R":
                    let toRotate = i.value / 90
                    directions.rotateLeft(positions: toRotate)
                case "F":
                    currentPosition = Coordinate(currentPosition.x + (direction.x * i.value), currentPosition.y + (direction.y * i.value))
                default: break
            }
        }
    }

    func navigateWithWaypoint() {
        for i in instructions {
            switch i.action {
                case "N", "S", "E", "W":
                    let modifier = [
                        "N": Coordinate(0, 1),
                        "S": Coordinate(0, -1),
                        "E": Coordinate(1, 0),
                        "W": Coordinate(-1, 0),
                    ][i.action]!
                    relativeWaypointPosition = Coordinate(relativeWaypointPosition.x + (modifier.x * i.value), relativeWaypointPosition.y + (modifier.y * i.value))
                case "L":
                    relativeWaypointPosition = relativeWaypointPosition.rotatePoint(aroundOrigin: Coordinate(0, 0), byDegrees: CGFloat(i.value))
                case "R":
                    relativeWaypointPosition = relativeWaypointPosition.rotatePoint(aroundOrigin: Coordinate(0, 0), byDegrees: CGFloat(i.value * -1))
                case "F":
                    currentPosition = Coordinate(currentPosition.x + (relativeWaypointPosition.x * i.value), currentPosition.y + (relativeWaypointPosition.y * i.value))
                default: break
            }
        }
    }
}

try main()
