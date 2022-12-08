// swift run Puzzle day8
import ArgumentParser
import Foundation

struct Day8: ParsableCommand {
  @Argument(help: "input file to evaluate")
  var file: String = "inputs/day8-inputs.txt"

  mutating func run() throws {
    guard
      let data = String(data: try! Data(contentsOf: URL(fileURLWithPath: file)), encoding: .utf8)
    else {
      throw Errors.InvalidFile
    }

    measure {
      print("part 1: \(part1_day8Puzzle(matrix: data.toIntMatrix()))")
    }

     measure {
       print("part 2: \(part2_day8ScenicScore(matrix: data.toIntMatrix()))")
     }
  }
}

func part1_day8Puzzle(matrix: [[Int]]) -> Int {
  var stack = matrix.variations()

  var coll = Set<Pos>()
  while !stack.isEmpty {
    let (arr, xy) = stack.removeFirst()
    let hits = raycastN(seq: arr, xy: xy)
    coll.formUnion(hits)
  }

  return coll.count
}

func part2_day8ScenicScore(matrix: [[Int]]) -> Int {
  var stack = matrix.variations()

  var coll = Set<Pos>()
  while !stack.isEmpty {
    let (arr, xy) = stack.removeFirst()
    let hits = raycastN(seq: arr, xy: xy)
    coll.formUnion(hits)
  }

  var gt = 0
  for pos in coll {
    let score =
      matrix.getWestScenicScore(x: pos.x, y: pos.y)
      * matrix.getEastScenicScore(x: pos.x, y: pos.y)
      * matrix.getNorthScenicScore(x: pos.x, y: pos.y)
      * matrix.getSouthScenicScore(x: pos.x, y: pos.y)
    gt = max(gt, score)
  }

  return gt
}

// return the (x , y) pos of "visible" trees (n directions)
func raycastN<S: Sequence>(seq: S, xy: XY) -> [Pos] where S.Element == Int {
  let fromFront = raycast1(seq: seq, xy: xy, dir: .forward)
  let fromBack = raycast1(seq: seq.reversed(), xy: xy, dir: .reverse)
  return fromFront + fromBack
}

// return the (x , y) pos of "visible" trees (unidirectional)
func raycast1<S: Sequence>(seq: S, xy: XY, dir: Dir) -> [Pos]
where S.Element == Int {
  var max = -1
  var list = [Pos]()
  for (offset, i) in seq.enumerated() {
    if i > max {
      list.append(xy.pos(xy: dir == .forward ? offset : seq.count - offset - 1))
      max = i
    }
    if max == 9 {
      // 9 is the max height for a tree in this example
      break
    }
  }
  return list
}

struct Pos: Hashable {
  let x: Int
  let y: Int
}

enum Dir {
  case forward
  case reverse
}

enum XY: Equatable {
  case column(row: Int)
  case row(column: Int)

  func pos(xy: Int) -> Pos {
    switch self {
    case .column(let row):
      return Pos(x: xy, y: row)
    case .row(let column):
      return Pos(x: column, y: xy)
    }
  }
}

extension Sequence where Element == Int {
  var count: Int { return reduce(0) { acc, row in acc + 1 } }
}

extension String {
  func toIntMatrix() -> [[Int]] {
    split(whereSeparator: \.isNewline)
      .map { String($0) }.map { Array($0) }.map {
        $0.map { Int(String($0))! }
      }
  }
}

extension Array where Element == [Int] {
  func variations() -> [([Int], XY)] {
    let s1 = self.enumerated().map { ($0.element, XY.column(row: $0.offset)) }
    let s2 = self.enumerated().map { (offset, element) -> ([Int], XY) in
      var arr = [Int]()

      for i in 0..<element.count {
        arr.append(self[i][offset])
      }

      return (arr, XY.row(column: offset))
    }
    return s1 + s2
  }
}

extension Array where Element == [Int] {
  func getNorthScenicScore(x: Int, y: Int) -> Int {
    let height = self[y][x]
    var score = 0

    var ptr = y - 1
    while ptr > -1 {
      let value = self[ptr][x]
      if value >= height {
        score = score + 1
        break
      }
      score = score + 1
      ptr = ptr - 1
    }

    return score
  }

  func getSouthScenicScore(x: Int, y: Int) -> Int {
    let height = self[y][x]
    var score = 0

    var ptr = y + 1
    while ptr < self.count {
      let value = self[ptr][x]
      if value >= height {
        score = score + 1
        break
      }
      score = score + 1
      ptr = ptr + 1
    }

    return score
  }

  func getWestScenicScore(x: Int, y: Int) -> Int {
    let height = self[y][x]
    var score = 0

    var ptr = x - 1
    while ptr > -1 {
      let value = self[y][ptr]
      if value >= height {
        score = score + 1
        break
      }
      score = score + 1
      ptr = ptr - 1
    }

    return score
  }

  func getEastScenicScore(x: Int, y: Int) -> Int {
    let height = self[y][x]
    var score = 0

    var ptr = x + 1
    while ptr < self[y].count {
      let value = self[y][ptr]
      if value >= height {
        score = score + 1
        break
      }
      score = score + 1
      ptr = ptr + 1
    }

    return score
  }

}
