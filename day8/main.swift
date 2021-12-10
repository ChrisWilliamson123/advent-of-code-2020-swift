import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode)
    let instructions = buildInstructions(from: input)
    
    let processor = Processor()
    try? processor.execute(instructions)
    print("Part 1:", processor.accumulator)

    let nops = processor.nopsExecuted
    let jmps = processor.jmpsExecuted

    // Create a list of patches, switching jmps to nops first then nops to jmps
    let patches: [Processor.Patch] = jmps.reversed().map({ ($0, "nop") }) + nops.reversed().map({ ($0, "jmp") })

    for p in patches {
        processor.reset()
        do {
            try processor.execute(instructions.applyPatch(p))
            break
        } catch {
            continue
        }
    }
    print("Part 2:", processor.accumulator)
}

try main()

class Processor {
    typealias Instruction = (operation: String, value: Int)
    typealias Patch = (instructionIndex: Int, newOperation: String)

    private(set) var accumulator = 0

    private var instructionPointer = 0

    private var instructionsExecuted: Set<Int> = []
    private(set) var nopsExecuted: [Int] = []
    private(set) var jmpsExecuted: [Int] = []

    func execute(_ instructions: [Instruction]) throws {
        while true {
            if instructionPointer >= instructions.count { return }
            if instructionsExecuted.contains(instructionPointer) {
                throw ProcessorError.infiniteLoop
            }

            let nextInstruction = instructions[instructionPointer]
            
            instructionsExecuted.insert(instructionPointer)

            switch nextInstruction.operation {
                case "nop":
                    nopsExecuted.append(instructionPointer)
                    instructionPointer += 1
                case "acc":
                    accumulator += nextInstruction.value
                    instructionPointer += 1
                case "jmp":
                    jmpsExecuted.append(instructionPointer)
                    instructionPointer += nextInstruction.value
                default:
                    throw ProcessorError.invalidOperation
            }
        }
    }


    func reset() {
        accumulator = 0
        instructionPointer = 0
        instructionsExecuted = []
        nopsExecuted = []
        jmpsExecuted = []
    }

    enum ProcessorError: Error {
        case invalidOperation
        case infiniteLoop
    }
}

extension Array where Element == Processor.Instruction {
    func applyPatch(_ patch: Processor.Patch) -> [Processor.Instruction] {
        var mutable = self
        mutable[patch.instructionIndex].operation = patch.newOperation
        return mutable
    }
}

private func buildInstructions(from instructionStrings: [String]) -> [Processor.Instruction] {
    instructionStrings.map({
        let split = $0.split(separator: " ")
        return (String(split[0]), Int(split[1])!)
    })
}
