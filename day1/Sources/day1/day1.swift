import ArgumentParser
import Foundation

@main
struct ElfCaloriesCounter: ParsableCommand {
    @Argument(help: "Input file to evaluate")
    var file: String

    mutating func run() throws {
        guard let data = String(data: try! Data(contentsOf: URL(fileURLWithPath: file)), encoding: .utf8) else {
            throw Errors.InvalidFile
        }

        var elfs = [Int]()
        var head = 0

        data.enumerateLines { (line, _) in
            if line.count == 0 {
                // maxCalories = max(maxCalories, head)
                elfs.append(head)
                head = 0
            } else {
                let calories = Int(line) ?? 0
                head = head + calories
            }
        }

        elfs.sort()
        elfs.reverse()

        var iter = elfs.makeIterator()
        
        print("part 1: \(elfs.max()!)")
        print("part 2: \(iter.next()! + iter.next()! + iter.next()!)")
    }
}

enum Errors: Error {
    case InvalidFile
}
