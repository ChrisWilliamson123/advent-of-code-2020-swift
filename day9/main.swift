import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [Int] = try readInput(fromTestFile: isTestMode)

    let preambleAmount = 25

    var firstInvalid = 0
    for i in preambleAmount..<input.count {
        let window = input[i-preambleAmount..<i]
        let combinations = getCombinations(input: Array(window), count: 2)
        if combinations.first(where: { $0.sum() == input[i] }) == nil {
            firstInvalid = input[i]
            print("Part 1:", firstInvalid)
            break
        }
    }

    let valuesUnderFirstInvalid = Array(input.filter({ $0 < firstInvalid }).reversed())
    
    for i in 0..<valuesUnderFirstInvalid.count {
        var total = 0
        var items: [Int] = []
        for j in i..<valuesUnderFirstInvalid.count {
            let value = valuesUnderFirstInvalid[j]
            total += value
            if total > firstInvalid {
                break
            }

            if total <= firstInvalid {
                items.append(value)
            }

            if total == firstInvalid {
                let sorted = items.sorted()
                print("Part 2:", sorted[0] + sorted[sorted.count - 1])
                return
            }
        }
    }
}

try main()
