//
//  Day8Tests.swift
//
//
//  Created by Alejandro Quesada on 12/8/22.
//

import XCTest

@testable import Puzzle

final class Day8Tests: XCTestCase {
  func testMatrixVariations() {
    let got = [[1, 2, 3], [4, 5, 6], [7, 8, 9]].variations()
    let want = [
      ([1, 2, 3], XY.column(row: 0)), ([4, 5, 6], XY.column(row: 1)),
      ([7, 8, 9], XY.column(row: 2)), ([1, 4, 7], XY.row(column: 0)),
      ([2, 5, 8], XY.row(column: 1)), ([3, 6, 9], XY.row(column: 2)),
    ]
    XCTAssert(got.map { $0.0 } == want.map { $0.0 })
    XCTAssert(got.map { $0.1 } == want.map { $0.1 })
  }

  func testRaycast1() {
    XCTAssertEqual(
      raycast1(seq: [1, 3, 5], xy: .column(row: 0), dir: .forward),
      [Pos(x: 0, y: 0), Pos(x: 1, y: 0), Pos(x: 2, y: 0)])
    XCTAssertEqual(
      raycast1(seq: [1, 3, 5].reversed(), xy: .column(row: 0), dir: .reverse),
      [Pos(x: 2, y: 0)])
  }

  func testRaycastN() {
    XCTAssertEqual(
      raycastN(seq: [1, 3, 5], xy: .column(row: 0)),
      [Pos(x: 0, y: 0), Pos(x: 1, y: 0), Pos(x: 2, y: 0), Pos(x: 2, y: 0)]
    )
  }

  func testToIntMatrix() {
    let got = """
      30373
      25512
      65332
      33549
      35390
      """.toIntMatrix()
    let want = [
      [3, 0, 3, 7, 3],
      [2, 5, 5, 1, 2],
      [6, 5, 3, 3, 2],
      [3, 3, 5, 4, 9],
      [3, 5, 3, 9, 0],
    ]
    XCTAssertEqual(got, want)
  }

  func testDay8PuzzleExample1() {
    let matrix = """
      30
      25
      """.toIntMatrix()
    XCTAssertEqual(part1_day8Puzzle(matrix: matrix), 4)
  }

  func testDay8PuzzleExample2() {
    let matrix = """
      303
      253
      345
      """.toIntMatrix()
    XCTAssertEqual(part1_day8Puzzle(matrix: matrix), 9)
  }

  func testDay8PuzzleExample3() {
    let matrix = """
      777
      757
      777
      """.toIntMatrix()
    XCTAssertEqual(part1_day8Puzzle(matrix: matrix), 8)
  }

  func testDay8PuzzleAOCExample() {
    let matrix = """
      30373
      25512
      65332
      33549
      35390
      """.toIntMatrix()
    XCTAssertEqual(part1_day8Puzzle(matrix: matrix), 21)
  }

  func testScenicScore() {
    let matrix = """
      30373
      25512
      65332
      33549
      35390
      """.toIntMatrix()
    XCTAssertEqual(part2_day8ScenicScore(matrix: matrix), 8)
  }

  func testGetScenicScores() {
    let matrix = """
      30373
      25512
      65332
      33549
      35390
      """.toIntMatrix()
    XCTAssertEqual(matrix.getNorthScenicScore(x: 2, y: 3), 2)
    XCTAssertEqual(matrix.getSouthScenicScore(x: 2, y: 3), 1)
    XCTAssertEqual(matrix.getWestScenicScore(x: 2, y: 3), 2)
    XCTAssertEqual(matrix.getEastScenicScore(x: 2, y: 3), 2)
  }
}
