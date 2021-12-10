import Foundation

private typealias Graph = [String: Set<String>]
private typealias WeightedGraph = [String: [String: Int]]

func main() throws {
    let isTestMode = CommandLine.arguments.contains("test")
    let input: [String] = try readInput(fromTestFile: isTestMode)
    
    let invertedGraph = buildInvertedGraph(input)
    var visited: Set<String> = []
    print(traverse(invertedGraph, "shiny gold", &visited) - 1)

    let weightedGraph = buildGraph(input)
    print(partTwoTraverse(weightedGraph, "shiny gold") - 1)
}

private func partTwoTraverse(_ graph: WeightedGraph, _ node: String) -> Int {
    var total = 1

    let children = graph[node]!

    for (colour, value) in children {
        total += value * partTwoTraverse(graph, colour)
    }

    return total
}

private func traverse(_ graph: Graph, _ node: String, _ visited: inout Set<String>) -> Int {
    if visited.contains(node) { return 0 }

    visited.insert(node)

    var numberOfBagColours = 1
    for neighbour in graph[node]! {
        numberOfBagColours += traverse(graph, neighbour, &visited)
    }

    return numberOfBagColours
}

private func buildGraph(_ input: [String]) -> WeightedGraph {
    var graph: WeightedGraph = [:]
    
    let regex = Regex("^(\\w+ \\w+) bags contain (.+)\\.$")

    for inputLine in input {
        let matches = regex.getMatches(in: inputLine)
        let destination = matches[0]

        let sources: [String: Int]
        if matches[1] == "no other bags" {
            sources = [:]
        } else {
            let separatedSources = matches[1].components(separatedBy: ", ")
            var tempSources: [String: Int] = [:]
            for source in separatedSources {
                let regex = Regex("(\\d+) (\\w+ \\w+) bags?")
                let matches = regex.getMatches(in: source)
                tempSources[matches[1]] = Int(matches[0])!
            }
            sources = tempSources
        }

        graph[destination] = sources
    }

    return graph
}

private func buildInvertedGraph(_ input: [String]) -> Graph {
    var graph: Graph = [:]
    
    let regex = Regex("^(\\w+ \\w+) bags contain (.+)\\.$")

    for inputLine in input {
        let matches = regex.getMatches(in: inputLine)
        let destination = matches[0]

        if graph[destination] == nil {
            graph[destination] = []
        }

        if matches[1] != "no other bags" {
            let sources = matches[1].components(separatedBy: ", ")

            for source in sources {
                let regex = Regex("(\\d+) (\\w+ \\w+) bags?")
                let matches = regex.getMatches(in: source)
                
                if graph[matches[1]] == nil {
                    graph[matches[1]] = [destination]
                } else {
                    graph[matches[1]] = graph[matches[1]]!.union([destination])
                }
            }
        }
    }

    return graph
}

try main()
