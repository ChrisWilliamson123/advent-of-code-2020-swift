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

try main()
