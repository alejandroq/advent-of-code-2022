import XCTest

@testable import Puzzle

class Day5Tests: XCTestCase {
  func testOneStep() {
    let lines = """
            move 1 from 2 to 1
      """
      .split(whereSeparator: \.isNewline)
      .map { String($0) }

    var state = [["Z", "N"], ["M", "C", "D"], ["P"]]

    XCTAssert(part1_day5Puzzle(state: &state, inputs: lines) == "DCP")
  }

  func testPart1Example() {
    let lines = """
            move 1 from 2 to 1
            move 3 from 1 to 3
            move 2 from 2 to 1
            move 1 from 1 to 2
      """
      .split(whereSeparator: \.isNewline)
      .map { String($0) }

    var state = [["Z", "N"], ["M", "C", "D"], ["P"]]

    XCTAssert(part1_day5Puzzle(state: &state, inputs: lines) == "CMZ")
  }

  func testPart2Partial2Steps() {
    let lines = """
            move 1 from 2 to 1
            move 3 from 1 to 3
      """
      .split(whereSeparator: \.isNewline)
      .map { String($0) }

    var state = [["Z", "N"], ["M", "C", "D"], ["P"]]

    XCTAssert(part2_day5Puzzle(state: &state, inputs: lines) == "CD")
  }

  func testPart2Partial3Steps() {
    let lines = """
            move 1 from 2 to 1
            move 3 from 1 to 3
            move 2 from 2 to 1
      """
      .split(whereSeparator: \.isNewline)
      .map { String($0) }

    var state = [["Z", "N"], ["M", "C", "D"], ["P"]]

    XCTAssert(part2_day5Puzzle(state: &state, inputs: lines) == "CD")
  }

  func testPart2Example() {
    let lines = """
            move 1 from 2 to 1
            move 3 from 1 to 3
            move 2 from 2 to 1
            move 1 from 1 to 2
      """
      .split(whereSeparator: \.isNewline)
      .map { String($0) }

    var state = [["Z", "N"], ["M", "C", "D"], ["P"]]

    XCTAssert(part2_day5Puzzle(state: &state, inputs: lines) == "MCD")
  }
}
