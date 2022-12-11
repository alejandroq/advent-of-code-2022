//
//  Day10Tests.swift
//
//
//  Created by Alejandro Quesada on 12/9/22.
//

import Algorithms
import XCTest

final class Day10Tests: XCTestCase {
  let testInstructions = String(
    data: try! Data(contentsOf: URL(fileURLWithPath: "inputs/day10-test-inputs.txt")),
    encoding: .utf8)!
    .split(whereSeparator: \.isNewline)
    .map { try! CPUInstructions.from(string: $0) }

  let prodInstructions = String(
    data: try! Data(contentsOf: URL(fileURLWithPath: "inputs/day10-inputs.txt")),
    encoding: .utf8)!
    .split(whereSeparator: \.isNewline)
    .map { try! CPUInstructions.from(string: $0) }

  func testParsingComputeInstructions() {
    let string = """
      noop
      addx 3
      addx -5
      noop
      """

    XCTAssertEqual(
      string.split(whereSeparator: \.isNewline).map { try! CPUInstructions.from(string: $0) }.count,
      4)
  }

  func testCPUCycleExecutes5ClicksAndReturnsNegative1() {
    let instructions = """
      noop
      addx 3
      addx -5
      """.split(whereSeparator: \.isNewline)
      .map { try! CPUInstructions.from(string: $0) }

    let processor = CPUProcessor()

    instructions.forEach { processor.process(instruction: $0) }

    XCTAssertEqual(
      processor.register(in: 1),
      1
    )

    XCTAssertEqual(
      processor.register(in: 2),
      1
    )

    XCTAssertEqual(
      processor.register(in: 3),
      4
    )

    XCTAssertEqual(
      processor.register(in: 4),
      4
    )

    XCTAssertEqual(
      processor.register(in: 5),
      -1
    )
  }

  func testCPUCycleExecutesNClicksAndReturnsVariousCycles() {
    let processor = CPUProcessor()
    testInstructions.forEach { processor.process(instruction: $0) }
    XCTAssertEqual(
      processor.register(in: 1),
      1
    )
    XCTAssertEqual(
      processor.register(in: 2),
      16
    )
    XCTAssertEqual(
      processor.register(in: 20),
      21
    )
    XCTAssertEqual(
      [
        20,
        60,
        100,
        140,
        180,
        220,
      ].map {
        $0 * processor.register(in: $0 - 1)
      }.sum(), 13_140
    )
  }

  func testCPUCycleExecutesPart1Puzzle() {
    let processor = CPUProcessor()
    prodInstructions.forEach { processor.process(instruction: $0) }
    XCTAssertEqual(
      [
        20,
        60,
        100,
        140,
        180,
        220,
      ].map {
        $0 * processor.register(in: $0 - 1)
      }.sum(), 13_220)
  }

  func testCPUProcessorCreateCRT() {
    XCTAssertEqual(CPUProcessor().crt.count, 6)
    XCTAssertEqual(CPUProcessor().crt[0].count, 40)
  }

  func testCPUProcessorDrawingToCRT() {
    let processor = CPUProcessor()
    testInstructions.forEach { processor.process(instruction: $0) }

    XCTAssertEqual(
      processor.getSpritePositionString(in: 1), "###.....................................")
    XCTAssertEqual(
      processor.getSpritePositionString(in: 2), "...............###......................")
    XCTAssertEqual(
      processor.getSpritePositionString(in: 3), "...............###......................")
    XCTAssertEqual(
      processor.getSpritePositionString(in: 4), "....###.................................")

    XCTAssertEqual(
      processor.crt.toCRTString().prefix(40), "##..##..##..##..##..##..##..##..##..##..")

    XCTAssertEqual(
      processor.crt[1].joined(), "###...###...###...###...###...###...###.")

    XCTAssertEqual(
      processor.crt.toCRTString(),
      """
      ##..##..##..##..##..##..##..##..##..##..
      ###...###...###...###...###...###...###.
      ####....####....####....####....####....
      #####.....#####.....#####.....#####.....
      ######......######......######......####
      #######.......#######.......#######.....
      """)
  }

  // TODO could you merge this rendering logic w/ SwiftUI? That'd be interesting.
  func testCPUProcessorPart2PuzzleDrawingToCRT() {
    let processor = CPUProcessor()
    prodInstructions.forEach { processor.process(instruction: $0) }
    XCTAssertEqual(
      processor.crt.toCRTString(),
      """
      ###..#..#..##..#..#.#..#.###..####.#..#.
      #..#.#..#.#..#.#.#..#..#.#..#.#....#.#..
      #..#.#..#.#..#.##...####.###..###..##...
      ###..#..#.####.#.#..#..#.#..#.#....#.#..
      #.#..#..#.#..#.#.#..#..#.#..#.#....#.#..
      #..#..##..#..#.#..#.#..#.###..####.#..#.
      """)  // RUAKHBEK
  }
}

// MARK - implementation

struct CPUState {
  let register: Int
  let instruction: CPUInstructions
}

class CPUProcessor {
  var cycles = [1]
  var position = 0
  var _crt = [String](repeating: ".", count: 40 * 6)

  var crt: [[String]] { _crt.chunks(ofCount: 40).map { Array($0) } }

  @inlinable
  func process(instruction: CPUInstructions) {
    switch instruction {
    case .noop:
      tick(update: 0)
    case let .addx(signal: signal):
      tick(update: 0)
      tick(update: signal)
    }
  }

  func tick(update: Int) {
    if getSpriteRange(in: cycles.count - 1).contains(position % 40) {
      _crt[position] = "#"
    }
    position = position + 1
    cycles.append(update)
  }

  // TODO belongs in CPUState(?)
  func getSpriteRange(in cycle: Int) -> ClosedRange<Int> {
    (self.register(in: cycle) - 1)...(self.register(in: cycle) + 1)
  }

  // TODO belongs in CPUState(?)
  func getSpritePositionString(in cycle: Int) -> String {
    let range = getSpriteRange(in: cycle)
    var row = [String](repeating: ".", count: 40)
    for i in range {
      row[i] = "#"
    }
    return row.joined()
  }

  @inlinable  // ABI stability yadayada - inlines for "performance", but good to know about compiler outcomes.
  func register(in cycle: Int) -> Int {
    cycles[0...cycle].sum()
  }
}

enum CPUInstructions {
  case noop
  case addx(signal: Int)
}

extension CPUInstructions {
  static func from(string: Substring) throws -> CPUInstructions {
    let split = string.split(separator: " ")
    switch split[0] {
    case "noop": return .noop
    case "addx": return .addx(signal: Int(split[1])!)
    default: throw "invalid input"
    }
  }
}

extension Sequence where Element == Int {
  func sum() -> Int {
    reduce(0) { partialResult, element in
      partialResult + element
    }
  }

  func product() -> Int {
    reduce(1) { partialResult, element in
      partialResult * element
    }
  }
}

extension Array where Element == [String] {
  fileprivate func toCRTString() -> String {
    self.map { $0.joined() }.reduce("") { partialResult, element in
      partialResult != "" ? "\(partialResult)\n\(element)" : element
    }
  }
}

extension String: Error {}
extension String: LocalizedError {
  public var errorDescription: String? { return self }
}
