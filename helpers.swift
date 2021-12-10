import Foundation

// READING INPUT
func readInput<T: StringInitialisable>(fromTestFile: Bool, separator: String = "\n") throws -> [T] {
    let inputPath = "./\(fromTestFile ? "test_" : "")input.txt"

    do {
        let contents = try String(contentsOfFile: inputPath, encoding: .utf8)
        return Array(contents.components(separatedBy: separator)).map({ T(String($0))! })
    }
    catch let error {
        print("Input parsing failed: \(error)")
        throw error
    }
}

protocol StringInitialisable {
    init?(_ string: String)
}

extension Int: StringInitialisable {}
extension Double: StringInitialisable {}
extension String: StringInitialisable {}

// ARRAY EXTENSIONS
extension ArraySlice where Element == Int {
    func sum() -> Int {
        self.reduce(0, +)
    }

    func multiply() -> Int {
        self.reduce(1, *)
    }
}

extension Array where Element == Int {
    func sum() -> Int {
        self.reduce(0, +)
    }

    func multiply() -> Int {
        self.reduce(1, *)
    }
}

// INT EXTENSIONS
extension Int {
    init?(_ char: Character) {
        self.init(String(char))
    }
}

extension UInt16 {
    init?(_ char: Character) {
        self.init(String(char))
    }
}

// STRING EXTENSIONS
extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    subscript (i: Int) -> Character {
        return [Character](self[i ..< i + 1])[0]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

struct Regex {
    private let regex: NSRegularExpression

    init(_ regex: String) {
        self.regex = try! NSRegularExpression(pattern: regex)
    }

    func doesMatch(_ text: String) -> Bool {
        let textRange = NSRange(text.startIndex..., in: text)
        return regex.firstMatch(in: text, options: [], range: textRange) != nil
    }

    func getMatches(in text: String, includeFullLengthMatch: Bool = false) -> [String] {
        let textRange = NSRange(text.startIndex..., in: text)

        let matches = regex.matches(in: text, range: textRange)
        guard let match = matches.first else { return [] }

        return (0..<match.numberOfRanges).compactMap({
            let matchRange = match.range(at: $0)

            if matchRange == textRange, !includeFullLengthMatch { return nil }

            guard let substringRange = Range(matchRange, in: text) else { return nil }
            return String(text[substringRange])
        })
    }
}