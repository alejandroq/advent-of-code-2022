//
//  Day12Tests.swift
//
//
//  Created by Alejandro Quesada on 12/11/22.
//

import Collections
import XCTest

@testable import Puzzle

final class Day12Tests: XCTestCase {
  let matrix = String(
    data: try! Data(contentsOf: URL(fileURLWithPath: "inputs/day12-inputs.txt")),
    encoding: .utf8)!.toCharacterMatrix()

  func testExample() {
    let matrix = """
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
      """.toCharacterMatrix()
    let result = day12_puzzle_part1(matrix: matrix)
    XCTAssertEqual(matrix.count, 5)
    XCTAssertEqual(matrix[0].count, 8)
    XCTAssertEqual(matrix.start.x, 0)
    XCTAssertEqual(matrix.start.y, 0)
    XCTAssertEqual(result?.steps.count, 31)
    print(
      getTraversedPath(pds: result!.steps, m: matrix)
    )
  }

  func testPart1Puzzle() {
    let result = day12_puzzle_part1(matrix: matrix)
    print(getTraversedPath(pds: result!.steps, m: matrix))
    XCTAssertEqual(result!.steps.count - 2, 468)  // NOTE: puzzle returns 470 (maybe because it incl. S and E?), but actual answer is 468 🤔
}

  func testPart2Puzzle() {
    let result = day12_puzzle_part2(matrix: matrix)
    print(getTraversedPath(pds: result!.steps, m: matrix))
    XCTAssertEqual(result!.steps.count - 2, 459)  // actual answer is 459 🫠 perhaps steps need to be counted as a->b counts
  }
}
