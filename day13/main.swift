import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode)
    
    let earliestDepartureEstimate = Int(input[0])!
    let allBusses = input[1].split(separator: ",").map({String($0)})
    let inServiceBusses = input[1].split(separator: ",").compactMap({ Int($0) })

    let earliestBusCanTake: (bus: Int, delay: Int) = inServiceBusses.map({ busTime in
        var delay = 0
        while (earliestDepartureEstimate + delay) % busTime != 0 {
            delay += 1
        }
        return (busTime, delay)
    }).min(by: { $0.1 < $1.1 })!

    print("Part 1:", earliestBusCanTake.0 * earliestBusCanTake.1)


    // Part 2
    var time = 0
    var stepSize = Int(allBusses[0])!

    for i in 1..<allBusses.count where Int(allBusses[i]) != nil {
        let busId = Int(allBusses[i])!
        while (time + i) % busId != 0 {
            time += stepSize
        }
        stepSize = stepSize * busId
    }
    print("Part 2:", time)
}

try main()
