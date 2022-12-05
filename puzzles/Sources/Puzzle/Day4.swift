// swift run puzzle day4
import ArgumentParser
import Foundation

infix operator ~==

struct Day4: ParsableCommand {
  @Argument(help: "input file to evaluate")
  var file: String = "inputs/day4-inputs.txt"

  mutating func run() throws {
    guard
      let data = String(data: try! Data(contentsOf: URL(fileURLWithPath: file)), encoding: .utf8)
    else {
      throw Errors.InvalidFile
    }

    var part1Counter = 0
    var part2Counter = 0

    data.split(whereSeparator: \.isNewline)
      .map { String($0) }
      .map { (line: String) in line.createRanges() }
      .forEach {
        (assignments: (ClosedRange<Int>, ClosedRange<Int>)) in let (assign1, assign2) = assignments
        if assign1.encompases(assign2) || assign2.encompases(assign1) {
          part1Counter = part1Counter + 1
        }

        if assign1.overlaps(assign2) {
          part2Counter = part2Counter + 1
        }
      }

    print("part 1: \(part1Counter)")
    print("part 2: \(part2Counter)")
  }
}

extension String {
  fileprivate func createRanges() -> (ClosedRange<Int>, ClosedRange<Int>) {
    let ranges = split(separator: ",").map { String($0) }.map { $0.createRange() }
    return (ranges.first!, ranges.last!)
  }
  fileprivate func createRange() -> ClosedRange<Int> {
    let ints = split(separator: "-").map { Int($0)! }
    let first = ints.first!
    let last = ints.last!
    return first...last
  }
}

extension ClosedRange {
  fileprivate func encompases(_ rhs: Self) -> Bool {
    clamped(to: rhs) == self
  }
}
