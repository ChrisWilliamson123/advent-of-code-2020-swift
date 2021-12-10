import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [Int] = try readInput(fromTestFile: isTestMode)
    print(input)
}

try main()
