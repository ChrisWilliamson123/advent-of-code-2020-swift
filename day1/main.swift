import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let expenseReportEntries: [Int] = try readInput(fromTestFile: isTestMode)

    print("Part 1:", getMatchingEntries(in: expenseReportEntries, numberOfEntriesToMatch: 2) ?? "No result")
    print("Part 2:", getMatchingEntries(in: expenseReportEntries, numberOfEntriesToMatch: 3) ?? "No result")
}

private func getMatchingEntries(in expenseReport: [Int], numberOfEntriesToMatch: Int) -> Int? {
    let combos = getCombinations(input: expenseReport, count: numberOfEntriesToMatch)
    let matchingCombination = combos.first(where: { $0.sum() == 2020 })
    return matchingCombination?.multiply()
}

func getCombinations(input: [Int], count: Int) -> [[Int]] {
    if count == 0 { return [[]] }

    if count == 1 { return input.map({ [$0] }) }

    let previousCombinations = getCombinations(input: input, count: count - 1)
    
    var combinations: [[Int]] = []

    for i in (0..<input.count) {
        for j in (0..<previousCombinations.count) where !previousCombinations[j].contains(input[i]) {
            combinations.append(previousCombinations[j] + [input[i]])
        }
    }

    return combinations
}

try main()
