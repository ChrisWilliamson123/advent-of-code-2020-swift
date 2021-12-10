import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode, separator: "\n\n")

    let passports = input.map({ Passport($0) })
    let partOne = passports.reduce(0, { currentTotal, passport in
        passport.isValid ? currentTotal + 1 : currentTotal
    })
    print("Part 1: \(partOne)")

    let partTwo = passports.reduce(0, { currentTotal, passport in
        passport.isValidWithValidation ? currentTotal + 1 : currentTotal
    })
    print("Part 2: \(partTwo)")
}

struct Passport {
    let fields: [String: String]
    let neededFields: [String] = [ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" ]

    var isValid: Bool {
        for f in neededFields {
            if fields[f] == nil {
                return false
            }
        }
        return true
    }

    var isValidWithValidation: Bool {
        for f in neededFields {
            guard let value = fields[f] else { return false }

            switch f {
                case "byr": if !(1920...2002).contains(Int(value)!) { return false }
                case "iyr": if !(2010...2020).contains(Int(value)!) { return false }
                case "eyr": if !(2020...2030).contains(Int(value)!) { return false }
                case "hgt":
                    let matches = Regex("^(\\d+)(cm|in)$").getMatches(in: value)
                    guard matches.count == 2 else { return false }
                    let range = matches[1] == "cm" ? (150...193) : (59...76)
                    let value = Int(matches[0])!
                    if !range.contains(value) { return false }
                case "hcl": if !Regex("#[0-9a-f]{6}").doesMatch(value) { return false }
                case "ecl": if ![ "amb", "blu", "brn", "gry", "grn", "hzl", "oth" ].contains(value) { return false }
                case "pid": if !Regex("^[0-9]{9}$").doesMatch(value) { return false }
                default: return false
            }
        }
        return true
    }

    init(_ passportString: String) {
        let split = passportString.split(separator: "\n").map({ $0.split(separator: " ") }).flatMap({ $0 })
        
        var fields: [String: String] = [:]
        split.forEach({
            let split = $0.split(separator: ":")
            fields[String(split[0])] = String(split[1])
        })

        self.fields = fields
    }
}


try main()
