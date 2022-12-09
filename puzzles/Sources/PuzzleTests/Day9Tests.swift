//
//  Day9Tests.swift
//
//
//  Created by Alejandro Quesada on 12/8/22.
//

import XCTest

@testable import Puzzle

final class Day9Tests: XCTestCase {
  func testParseInstruction() {
    let txt = """
      L 1
      R 2
      U 1
      D 2
      """

    XCTAssertEqual(
      txt.toInstructions(),
      [
        Instruction(direction: .L, distance: 1),
        Instruction(direction: .R, distance: 2),
        Instruction(direction: .U, distance: 1),
        Instruction(direction: .D, distance: 2),
      ])
  }

  func testMovement() {
    let tail = Pointer(x: 0, y: 0, tail: nil)
    let head = Pointer(x: 0, y: 0, tail: tail)
    XCTAssertEqual(head.pos, Pos(x: 0, y: 0))

    head.processN(instruction: Instruction(direction: .R, distance: 1))
    XCTAssertEqual(head.pos, Pos(x: 1, y: 0))
    XCTAssertEqual(tail.pos, Pos(x: 0, y: 0))

    head.processN(instruction: Instruction(direction: .R, distance: 1))
    XCTAssertEqual(head.pos, Pos(x: 2, y: 0))
    XCTAssertEqual(tail.pos, Pos(x: 1, y: 0))

    head.processN(instruction: Instruction(direction: .L, distance: 1))
    XCTAssertEqual(head.pos, Pos(x: 1, y: 0))
    XCTAssertEqual(tail.pos, Pos(x: 1, y: 0))

    head.processN(instruction: Instruction(direction: .U, distance: 1))
    XCTAssertEqual(head.pos, Pos(x: 1, y: 1))
    XCTAssertEqual(tail.pos, Pos(x: 1, y: 0))

    head.processN(instruction: Instruction(direction: .L, distance: 1))
    XCTAssertEqual(head.pos, Pos(x: 0, y: 1))
    XCTAssertEqual(tail.pos, Pos(x: 1, y: 0))

    head.processN(instruction: Instruction(direction: .D, distance: 2))
    XCTAssertEqual(head.pos, Pos(x: 0, y: -1))
    XCTAssertEqual(tail.pos, Pos(x: 1, y: 0))

    head.processN(instruction: Instruction(direction: .D, distance: 100))
    XCTAssertEqual(head.pos, Pos(x: 0, y: -101))
    XCTAssertEqual(tail.pos, Pos(x: 0, y: -100))
  }

  func testLongMovementWalk() {
    let t3 = Pointer(x: 0, y: 0, tail: nil)
    let t2 = Pointer(x: 0, y: 0, tail: t3)
    let t1 = Pointer(x: 0, y: 0, tail: t2)
    let head = Pointer(x: 0, y: 0, tail: t1)

    head.processN(instruction: Instruction(direction: .R, distance: 1))
    XCTAssertEqual(head.pos, Pos(x: 1, y: 0))
    XCTAssertEqual(t1.pos, Pos(x: 0, y: 0))

    head.processN(instruction: Instruction(direction: .R, distance: 1))
    XCTAssertEqual(head.pos, Pos(x: 2, y: 0))
    XCTAssertEqual(t1.pos, Pos(x: 1, y: 0))
    XCTAssertEqual(t2.pos, Pos(x: 0, y: 0))

    head.processN(instruction: Instruction(direction: .R, distance: 1))
    XCTAssertEqual(head.pos, Pos(x: 3, y: 0))
    XCTAssertEqual(t1.pos, Pos(x: 2, y: 0))
    XCTAssertEqual(t2.pos, Pos(x: 1, y: 0))
    XCTAssertEqual(t3.pos, Pos(x: 0, y: 0))
  }

  func testLongMovementSprint() {
    let t3 = Pointer(x: 0, y: 0, tail: nil)
    let t2 = Pointer(x: 0, y: 0, tail: t3)
    let t1 = Pointer(x: 0, y: 0, tail: t2)
    let head = Pointer(x: 0, y: 0, tail: t1)

    head.processN(instruction: Instruction(direction: .R, distance: 3))
    XCTAssertEqual(head.pos, Pos(x: 3, y: 0))
    XCTAssertEqual(t1.pos, Pos(x: 2, y: 0))
    XCTAssertEqual(t2.pos, Pos(x: 1, y: 0))
    XCTAssertEqual(t3.pos, Pos(x: 0, y: 0))
  }

  func testDay9P1ShortSnakeExample() {
    let instructions = """
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
      """.toInstructions()

    XCTAssertEqual(part1_day9Puzzle_smallSnake(instructions: instructions), 13)
  }

  func testDay9P1() throws {
    guard
      let data = String(
        data: try! Data(contentsOf: URL(fileURLWithPath: "inputs/day9-inputs.txt")), encoding: .utf8
      )
    else {
      throw Errors.InvalidFile
    }

    XCTAssertEqual((part1_day9Puzzle_smallSnake(instructions: data.toInstructions())), 5683)
  }

  func testDay9P2LongSnakeExample1() {
    let instructions = """
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
      """.toInstructions()

    let t9 = Pointer(x: 0, y: 0, tail: nil)
    let t8 = Pointer(x: 0, y: 0, tail: t9)
    let t7 = Pointer(x: 0, y: 0, tail: t8)
    let t6 = Pointer(x: 0, y: 0, tail: t7)
    let t5 = Pointer(x: 0, y: 0, tail: t6)
    let t4 = Pointer(x: 0, y: 0, tail: t5)
    let t3 = Pointer(x: 0, y: 0, tail: t4)
    let t2 = Pointer(x: 0, y: 0, tail: t3)
    let t1 = Pointer(x: 0, y: 0, tail: t2)
    let head = Pointer(x: 0, y: 0, tail: t1)

    instructions.forEach {
      head.processN(instruction: $0)
    }

    XCTAssert(t3.path.count > 1)
    XCTAssertEqual(t6.path.count, 1)
    XCTAssertEqual(t7.path.count, 1)
    XCTAssertEqual(t8.path.count, 1)
    XCTAssertEqual(t9.path.count, 1)
  }

  func testDay9P2LongSnakeExample2() {
    let instructions = """
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
      """.toInstructions()

    XCTAssertEqual(part2_day9Puzzle_largeSnake(instructions: instructions), 36)
  }
}
