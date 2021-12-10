import Foundation

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let instructions: [String] = try readInput(fromTestFile: isTestMode)
    
    let processor = Processor(instructions)
    try? processor.execute()
    print("Part 1:", processor.accumulator)

    let nops = processor.nopsExecuted
    let jmps = processor.jmpsExecuted

    // Create a list of patches, switching jmps to nops first then nops to jmps
    let patches: [Processor.Patch] = jmps.reversed().map({ ($0, "nop") }) + nops.reversed().map({ ($0, "jmp") })

    for p in patches {
        processor.reset()
        do {
            try processor.execute(patch: p)
            break
        } catch {
            continue
        }
    }
    print("Part 2:", processor.accumulator)
}

class Processor {
    typealias Instruction = (operation: String, value: Int)

    private(set) var accumulator = 0
    private var instructionPointer = 0
    private var instructionsExecuted: Set<Int> = []
    private(set) var nopsExecuted: [Int] = []
    private(set) var jmpsExecuted: [Int] = []

    private let instructions: [Instruction]

    init(_ instructions: [String]) {
        self.instructions = instructions.map({
            let split = $0.split(separator: " ")
            return (String(split[0]), Int(split[1])!)
        })
    }

    func execute(instructions: [Instruction]? = nil) throws {
        let instructions = instructions ?? self.instructions
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

    typealias Patch = (instructionIndex: Int, newOperation: String)

    func execute(patch: Patch) throws {
        var instructions = self.instructions
        instructions[patch.instructionIndex].operation = patch.newOperation
        try execute(instructions: instructions)
    }

    func reset() {
        accumulator = 0
        instructionPointer = 0
        instructionsExecuted = []
        nopsExecuted = []
        jmpsExecuted = []
    }

    // struct InvalidOperationError: LocalizedError {

    //     let operation: String

    //     var errorDescription: String? { "Invalid operation: \(operation)" }
    // }

    // struct InfiniteLoopError: LocalizedError {

    //     var errorDescription: String? { "The processor has hit an infinite loop" }
    // }

    enum ProcessorError: Error {
        case invalidOperation
        case infiniteLoop
    }
}

try main()
