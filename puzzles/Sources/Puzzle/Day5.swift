// swift run puzzle day5
import ArgumentParser
import Foundation

struct Day5: ParsableCommand {
  @Argument(help: "input file to evaluate")
  var file: String = "inputs/day5-inputs.txt"

  var state = [
    [
      "P",
      "F",
      "M",
      "Q",
      "W",
      "G",
      "R",
      "T",
    ],
    [
      "H",
      "F",
      "R",
    ],
    [
      "P",
      "Z",
      "R",
      "V",
      "G",
      "H",
      "S",
      "D",
    ],
    [
      "Q",
      "H",
      "P",
      "B",
      "F",
      "W",
      "G",
    ],
    [
      "P",
      "S",
      "M",
      "J",
      "H",
    ],
    [
      "M",
      "Z",
      "T",
      "H",
      "S",
      "R",
      "P",
      "L",
    ],
    [
      "P",
      "T",
      "H",
      "N",
      "M",
      "L",
    ],
    [
      "F",
      "D",
      "Q",
      "R",
    ],
    [
      "D",
      "S",
      "C",
      "N",
      "L",
      "P",
      "H",
    ],
  ]

  mutating func run() throws {
    guard
      let data = String(data: try! Data(contentsOf: URL(fileURLWithPath: file)), encoding: .utf8)
    else {
      throw Errors.InvalidFile
    }
    part1_day5Puzzle(
      state: &state, inputs: data.split(whereSeparator: \.isNewline).map { String($0) })

    part2_day5Puzzle(
      state: &state, inputs: data.split(whereSeparator: \.isNewline).map { String($0) })
  }
}

@discardableResult
func part1_day5Puzzle(state: inout [[String]], inputs: [String]) -> String {
  print("init: \(state.getTopLetters())")
  inputs
    .map { $0.toMove() }
    .forEach { state.move9000($0) }
  print("conclude: \(state.getTopLetters())")
  return state.getTopLetters()
}

@discardableResult
func part2_day5Puzzle(state: inout [[String]], inputs: [String]) -> String {
  print("init: \(state.getTopLetters())")
  inputs
    .map { $0.toMove() }
    .forEach { state.move9001($0) }
  print("conclude: \(state.getTopLetters())")
  return state.getTopLetters()
}

struct Move {
  let loops: Int
  let start: Int
  let end: Int
}

extension Array where Element == [String] {
  fileprivate mutating func move9001(_ move: Move) {
    var elems = [String]()

    defer {
      self[move.end].append(contentsOf: elems.reversed())
    }

    for _ in 1...move.loops {
      guard let el = self[move.start].popLast() else {
        // nothing else to pop!
        return
      }
      elems.append(el)
    }
  }

  fileprivate mutating func move9000(_ move: Move) {
    for _ in 1...move.loops {
      guard let el = self[move.start].popLast() else {
        // nothing else to pop!
        return
      }
      self[move.end].append(el)
    }
  }

  fileprivate func getTopLetters() -> String {
    self.map { $0.last }
      .compactMap { $0 }
      .reduce("") { agg, el in
        "\(agg)\(el)"
      }
  }
}

extension String {
  fileprivate func toMove() -> Move {
    let matches = self.components(separatedBy: .decimalDigits.inverted)
      .filter { $0 != "" }
      .map { Int($0)! }
    return Move(loops: matches[0], start: matches[1] - 1, end: matches[2] - 1)
  }
}
