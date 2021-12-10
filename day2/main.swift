import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode)

    let part1PoliciedPasswords = input.map({ PoliciedPassword($0, policyType: .range) })
    let part2PoliciedPasswords = input.map({ PoliciedPassword($0, policyType: .position) })

    print("Part 1: \(getValidPasswordCount(for: part1PoliciedPasswords))")
    print("Part 2: \(getValidPasswordCount(for: part2PoliciedPasswords))")
}

private func getValidPasswordCount(for policiedPasswords: [PoliciedPassword]) -> Int {
    policiedPasswords.reduce(0, { $1.isPasswordValid ? $0 + 1 : $0 })
}

enum PolicyType {
    case range
    case position
}

struct PoliciedPassword {
    let policy: PasswordPolicy
    let password: String

    var isPasswordValid: Bool {
        policy.validatePassword(password)
    }

    init(_ passwordEntry: String, policyType: PolicyType) {
        let split = passwordEntry.components(separatedBy: ": ")
        password = split[1]
        policy = policyType == .position ? CharacterExistsAtPositionPolicy(split[0]) : CharacterCountInRangePolicy(split[0])
    }

    struct CharacterCountInRangePolicy: PasswordPolicy {
        let range: ClosedRange<Int>
        let value: Character

        init(_ policyString: String) {
            let split = policyString.split(separator: " ")
            value = [Character](split[1])[0]

            let rangeSplit = split[0].split(separator: "-")
            range = Int(rangeSplit[0])!...Int(rangeSplit[1])!
        }

        func validatePassword(_ password: String) -> Bool {
            let countedSet = NSCountedSet(array: [Character](password))
            let countForPoliciedCharacter = countedSet.count(for: value)
            return range.contains(countForPoliciedCharacter)
        }
    }

    struct CharacterExistsAtPositionPolicy: PasswordPolicy {
        let firstPosition: Int
        let secondPosition: Int
        let value: Character

        init(_ policyString: String) {
            let split = policyString.split(separator: " ")
            value = [Character](split[1])[0]

            let positionsSplit = split[0].split(separator: "-")
            firstPosition = Int(positionsSplit[0])! - 1
            secondPosition = Int(positionsSplit[1])! - 1
        }

        func validatePassword(_ password: String) -> Bool {
            (password[firstPosition] == value) ^ (password[secondPosition] == value)
        }
    }
}

protocol PasswordPolicy {
    func validatePassword(_ password: String) -> Bool
}

extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}

try main()
