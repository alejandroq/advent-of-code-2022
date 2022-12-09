// swift run Puzzle day9
import ArgumentParser
import Foundation

func part1_day9Puzzle_smallSnake(instructions: [Instruction]) -> Int {
  let tail = Pointer(x: 0, y: 0, tail: nil)
  let head = Pointer(x: 0, y: 0, tail: tail)

  instructions.forEach {
    head.processN(instruction: $0)
  }

  return tail.path.count
}

func part2_day9Puzzle_largeSnake(instructions: [Instruction]) -> Int {
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

  return t9.path.count
}

// MARK - Pointer

protocol Tail {
  func tail(head: Pos)
}

class Pointer {
  var pos: Pos
  var path: Set<Pos>
  let tail: Tail?

  init(x: Int, y: Int, tail: Tail?) {
    self.pos = Pos(x: x, y: y)
    self.tail = tail
    self.path = Set([self.pos])
  }

  func processN(instruction: Instruction) {
    for _ in 1...instruction.distance {
      self.process1(direction: instruction.direction)
    }
  }

  private func process1(direction: Direction) {
    switch direction {
    case .D:
      self.pos = self.pos.updateY(-1)
    case .R:
      self.pos = self.pos.updateX(1)
    case .U:
      self.pos = self.pos.updateY(1)
    case .L:
      self.pos = self.pos.updateX(-1)
    }

    tail?.tail(head: self.pos)
  }

  func assume(_ pos: Pos) {
    self.pos = pos
    self.path.insert(pos)
  }
}

extension Pointer: Tail {
  func tail(head: Pos) {
    let (dx, dy) = head.getDistance(from: self.pos)
    var (x, y) = (self.pos.x, self.pos.y)

    if abs(dx) <= 1 && abs(dy) <= 1 {
      // don't update position if already touching
      return
    }

    // part 2 rope behavior vs part 1 mimicking prev head -
    // needed the internet's help here 👌 thanks fam.
    if dx == 0 {
      y = y + (dy == 2 ? 1 : -1)
    } else if dy == 0 {
      x = x + (dx == 2 ? 1 : -1)
    } else {
      // not on same row or column, move diagonally
      y = y + (dy > 0 ? 1 : -1)
      x = x + (dx > 0 ? 1 : -1)
    }

    self.assume(Pos(x: x, y: y))
    tail?.tail(head: self.pos)
  }
}

extension Pos {
  func getDistance(from rhs: Pos) -> (dx: Int, dy: Int) {
    (dx: x - rhs.x, dy: y - rhs.y)
  }
  func updateX(_ x2: Int) -> Pos { Pos(x: x + x2, y: y) }
  func updateY(_ y2: Int) -> Pos { Pos(x: x, y: y + y2) }
}

// MARK - Instruction

struct Instruction: Equatable {
  let direction: Direction
  let distance: Int
}

enum Direction: String {
  case R
  case L
  case U
  case D
}

extension String {
  func toInstructions() -> [Instruction] {
    split(whereSeparator: \.isNewline)
      .map { String($0) }
      .map { $0.split(separator: " ").map { String($0) } }
      .map { ($0[0], $0[1]) }
      .map { Instruction(direction: Direction(rawValue: $0.0)!, distance: Int($0.1)!) }
  }
}

// MARK - Boilerplate Swift Argument Parser code

struct Day9: ParsableCommand {
  @Argument(help: "input file to evaluate")
  var file: String = "inputs/day9-inputs.txt"

  mutating func run() throws {
    guard
      let data = String(data: try! Data(contentsOf: URL(fileURLWithPath: file)), encoding: .utf8)
    else {
      throw Errors.InvalidFile
    }

    measure {
      print("part 1: \(part1_day9Puzzle_smallSnake(instructions: data.toInstructions()))")
    }

    measure {
      print("part 2: \(part2_day9Puzzle_largeSnake(instructions: data.toInstructions()))")
    }
  }
}
