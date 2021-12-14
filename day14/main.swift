import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode)

    var memory: [Int: Int] = [:]
    var mask: String = ""

    let memRegex = Regex("mem\\[(\\d+)\\] = (\\d+)")

    typealias MemoryInstruction = (index: Int, value: Int)
    for line in input {
        // Check if the line is a mask line
        if line[1] == "a" {
            mask = line.components(separatedBy: " = ")[1]
            continue
        }

        let groups = memRegex.getMatches(in: line)
        let inst: MemoryInstruction = (Int(groups[0])!, Int(groups[1])!)

        // let valueBinString = pad(string: String(inst.value, radix: 2), toSize: 36)
        let valueBinString = String(inst.value, radix: 2).padded(toSize: 36)
        let masked = applyMask(mask, to: valueBinString)
        let maskedDecimal = Int(masked, radix: 2)!
        memory[inst.index] = maskedDecimal
    }

    print("Part 1:", memory.values.map({ $0 }).sum())
    

    // Part 2
    memory = [:]
    for line in input {
        // Check if the line is a mask line
        if line[1] == "a" {
            mask = line.components(separatedBy: " = ")[1]
            continue
        }

        let groups = memRegex.getMatches(in: line)
        let inst: MemoryInstruction = (Int(groups[0])!, Int(groups[1])!)

        let memoryBinString = String(inst.index, radix: 2).padded(toSize: 36)
        let maskedResults = applyMemoryMask(mask, to: memoryBinString)

        for addr in maskedResults {
            let addrDecimal = Int(addr, radix: 2)!
            memory[addrDecimal] = inst.value
        }
    }

    print("Part 2:", memory.values.map({ $0 }).sum())
}

func applyMask(_ mask: String, to input: String) -> String {
    assert(mask.count == input.count, "Mask and input are not same length")

    var masked = ""
    for i in 0..<mask.count {
        let maskChar: String = mask[i]
        let inputChar: String = input[i]

        if maskChar == "X" {
            masked += inputChar
        } else {
            masked += maskChar
        }
    }

    return masked
}

func applyMemoryMask(_ mask: String, to input: String) -> [String] {
    assert(mask.count == input.count, "Mask and input are not same length")

    let masked: [Character] = (0..<mask.count).map({
        switch Character(mask[$0]) {
            case "0": return input[$0]
            case "1": return "1"
            default: return "X"
        }
    })

    let xIndexes = (0..<masked.count).filter({ masked[$0] == "X" })
    let xCount = xIndexes.count

    if xCount == 0 { return [String(masked)] }

    var result: [String] = []
    let combinations = power(2, xCount)
    let binStrings = (0..<combinations).map({ String($0, radix: 2).padded(toSize: xCount) })

    for binaryString in binStrings {
        var thisMasked = [Character](masked)
        for i in 0..<xIndexes.count {
            thisMasked[xIndexes[i]] = binaryString[i]
        }
        result.append(String(thisMasked))
    }

    return result
}

try main()
