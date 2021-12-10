import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode)


    let seatIDs: [Int] = input.map(getSeatID)

    print("Part 1: \(seatIDs.max()!)")

    let sortedSeatIDs = seatIDs.sorted()

    for i in 1..<sortedSeatIDs.count {
        if sortedSeatIDs[i] + 1 != sortedSeatIDs[i+1] {
            print("Part 2: \(sortedSeatIDs[i] + 1 + 1)")
            break
        }
    }
}

private func getSeatID(_ boardingPass: String) -> Int {
    let regex = Regex("([F|B]{7})([R|L]{3})")
    let rowAndColumn = regex.getMatches(in: boardingPass)
    let row = getRow(using: rowAndColumn[0])
    let column = getColumn(using: rowAndColumn[1])
    return (row * 8) + column
}

private func getRow(using rowString: String) -> Int {
    let binaryString: String = rowString
        .replacingOccurrences(of: "F", with: "0")
        .replacingOccurrences(of: "B", with: "1")
    return Int(binaryString, radix: 2)!
}

private func getColumn(using columnString: String) -> Int {
    let binaryString: String = columnString
        .replacingOccurrences(of: "R", with: "1")
        .replacingOccurrences(of: "L", with: "0")
    return Int(binaryString, radix: 2)!
}

try main()
