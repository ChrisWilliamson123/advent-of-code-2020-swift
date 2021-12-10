import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode, separator: "\n\n")

    let groups = input.map({ Group($0) })
    print("Part 1:", groups.map({ $0.totalNumberOfQuestionsAnsweredYesToByAnyone() }).sum())

    print("Part 2:", groups.map({ $0.totalNumberOfQuestionsAnsweredYesToByEveryone() }).sum())
}

class Group {
    typealias Person = [Character]
    let people: [Person]

    init(_ groupInput: String) {
        people = groupInput.split(separator: "\n").map({ [Character]($0) })
    }

    func totalNumberOfQuestionsAnsweredYesToByAnyone() -> Int {
        var result: Set<Character> = []
        for p in people {
            for c in p { result.insert(c) }
        }

        return result.count
    }

    func totalNumberOfQuestionsAnsweredYesToByEveryone() -> Int {
        var result: Set<Character> = []

        for p in people {
            for c in p {
                var includeChar = true
                for p2 in people {
                    if !p2.contains(c) {
                        includeChar = false
                        break
                    }
                }
                if includeChar { result.insert(c) }
            }
        }

        return result.count
    }
}

try main()
