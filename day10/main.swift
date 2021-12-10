import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let adapters: [Int] = try readInput(fromTestFile: isTestMode)

    var sortedAdapters = adapters.sorted()
    sortedAdapters.insert(0, at: 0)
    sortedAdapters.append(sortedAdapters[sortedAdapters.count - 1] + 3)
    var differenceCounts: [Int: Int] = [:]

    for i in 1..<sortedAdapters.count {
        let difference = sortedAdapters[i] - sortedAdapters[i-1]
        if differenceCounts[difference] != nil {
            differenceCounts[difference]! += 1
        } else {
            differenceCounts[difference] = 1            
        }
    }

    print("Part 1:", differenceCounts[1]! * differenceCounts[3]!)


    // Part 2
    var memo: [Int: Int] = [:]
    print("Part 2:", numWays(adapters: sortedAdapters, memo: &memo))

}

private func numWays(adapters: [Int], index: Int = 0, memo: inout [Int: Int]) -> Int {
    if let alreadyComputedCount = memo[index] {
        return alreadyComputedCount
    }
    if index == adapters.count - 1 { return 1 }

    var total = 0

    for i in 1...3 {
        if ((index + i) < adapters.count) && ((adapters[index+i] - adapters[index]) <= 3) {
            total += numWays(adapters: adapters, index: index + i, memo: &memo)
        }
    }

    memo[index] = total
    return total
}

try main()
