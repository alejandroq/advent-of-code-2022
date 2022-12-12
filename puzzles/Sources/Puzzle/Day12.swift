// swift run Puzzle day12
///
///
/// ## CLI results (debug)
/// ```
/// time swift run Puzzle day12
///   Building for debugging...
///   Build complete! (0.08s)
///   part 1: Optional(470)
///   Time elapsed:
///     275948.458µs
///     275.94845799999996ms
///     0.27594845799999995s
///   part 2: Optional(461)
///   Time elapsed:
///     20392827.25µs
///     20392.82725ms
///     20.39282725s
///   swift run Puzzle day12 20.74s user 0.35s system 99% cpu 21.266 total
/// ```
///
/// ## CLI results (release)
/// ```
/// swift build --configuration release
/// time ./.build/release/Puzzle day12
/// time ./.build/release/Puzzle day12
///   part 1: Optional(470)
///   Time elapsed:
///     73044.75µs
///     73.04475ms
///     0.07304474999999999s
///   part 2: Optional(461)
///   Time elapsed:
///     3809141.25µs
///     3809.14125ms
///     3.80914125s
///   ./.build/release/Puzzle day12 3.85s user 0.04s system 95% cpu 4.089 total
/// ```
import Foundation
import ArgumentParser
import Collections

struct Position: Equatable, Hashable, CustomStringConvertible {
  var x: Int
  var y: Int

  var description: String {
    "(x: \(x), y: \(y))"
  }

  func towards(_ direction: Direction) -> Position {
    switch direction {
    case .D:
      return Position(x: x, y: y - 1)
    case .U:
      return Position(x: x, y: y + 1)
    case .L:
      return Position(x: x - 1, y: y)
    case .R:
      return Position(x: x + 1, y: y)
    }
  }
}

struct PositionDirection: Hashable {
  let position: Position
  let direction: Direction
}

struct PositionSteps: Hashable {
  let position: Position
  let steps: OrderedSet<PositionDirection>
}

func day12_puzzle_part1(matrix: [[Character]]) -> PositionSteps? {
  bfs(matrix: matrix, start: matrix.start)
}

func day12_puzzle_part2(matrix: [[Character]]) -> PositionSteps? {
  return matrix.lowestElevationPositions
    .map { bfs(matrix: matrix, start: $0) }
    .compactMap { $0 }
    .sorted { lhs, rhs in lhs.steps.count < rhs.steps.count }
    .first
}

func bfs(matrix: [[Character]], start: Position) -> PositionSteps? {
  var queue = Deque<PositionSteps>([
    PositionSteps(position: start, steps: OrderedSet())
  ])
  var visitedDirections = Set<String>()  // "pA-pB"
  while let head = queue.popFirst() {
    let position = head.position
    if matrix.getLetterInPosition(position) == "E" {
      return head
    }
    for d in [Direction.D, .L, .U, .R] {
      let proposed = position.towards(d)
      if matrix.isLegal(pA: position, pB: proposed)
        && !visitedDirections.contains("\(position) -> \(proposed)")
      {
        visitedDirections.insert("\(position) -> \(proposed)")
        queue.append(
          PositionSteps(
            position: proposed,
            steps: head.steps.union(
              OrderedSet(arrayLiteral: PositionDirection(position: position, direction: d)))))
      }
    }
  }
  return nil
}

// MARK - globals
let aScalars = "a".unicodeScalars
let lettersToElevation = (0..<26).map {  // lowest to highest
  i in (Character(UnicodeScalar(aScalars[aScalars.startIndex].value + i)!), i)
}.reduce(into: ["S".first!: 0, "E".first!: 26]) { partialResult, record in
  partialResult[record.0] = Int(record.1)
}

// MARK - extensions
extension Array where Element == [Character] {
  fileprivate var lowestElevationPositions: [Position] {
    var positions = [Position]()
    self.enumerated().forEach { (y, elements) in
      elements.enumerated().forEach { (x, element) in
        if element == "a" {
          positions.append(Position(x: x, y: y))
        }
      }
    }
    return positions
  }
  var start: Position {
    var x: Int!
    var y: Int!
    y = self.firstIndex(where: { arr in
      guard
        let _x = arr.firstIndex(where: { char in
          char == "S"
        })
      else {
        return false
      }
      x = _x
      return true
    })!
    return Position(x: x, y: y)
  }
  var end: Position {
    var x: Int!
    var y: Int!
    y = self.firstIndex(where: { arr in
      guard
        let _x = arr.firstIndex(where: { char in
          char == "E"
        })
      else {
        return false
      }
      x = _x
      return true
    })!
    return Position(x: x, y: y)
  }
  fileprivate func getLetterInPosition(_ p: Position) -> Character? {
    self[safe: p.y]?[safe: p.x]
  }
  fileprivate func isLegal(pA: Position, pB: Position) -> Bool {
    let curr = lettersToElevation[getLetterInPosition(pA)!]!
    guard let proposed = getLetterInPosition(pB) else {
      return false
    }
    let next = lettersToElevation[proposed]!
    return next <= curr + 1
  }
}
func getTraversedPath(pds: OrderedSet<PositionDirection>, m: [[Character]]) -> String {
  var canvas = Array(repeating: [Character](repeating: ".", count: m[0].count), count: m.count)
  let getDirectionCharacter = { (dir: Direction) -> Character in
    switch dir {
    case .D: return "^"
    case .U: return "v"
    case .L: return "<"
    case .R: return ">"
    }
  }
  pds.forEach { positionDirection in
    let position = positionDirection.position
    let direction = positionDirection.direction
    canvas[position.y][position.x] = getDirectionCharacter(direction)
  }
  let start = m.start
  canvas[start.y][start.x] = "S"
  let end = m.end
  canvas[end.y][end.x] = "E"
  return String(canvas.map { String($0) }.joined(by: "\n"))
}
extension String {
  func toCharacterMatrix() -> [[Character]] {
    split(whereSeparator: \.isNewline).map { Array($0) }
  }
}
extension Collection {
  // Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}


// MARK - Boilerplate Swift Argument Parser code

struct Day12: ParsableCommand {
  @Argument(help: "input file to evaluate")
  var file: String = "inputs/day12-inputs.txt"

  mutating func run() throws {
    let data = String(data: try! Data(contentsOf: URL(fileURLWithPath: file)), encoding: .utf8)!.toCharacterMatrix()

    measure {
      print("part 1: \(day12_puzzle_part1(matrix: data)?.steps.count)")
    }

    measure {
      print("part 2: \(day12_puzzle_part2(matrix: data)?.steps.count)")
    }
  }
}

