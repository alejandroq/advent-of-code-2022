import ArgumentParser
import Foundation

let points: [Character: Int] = [
  "a": 1,
  "b": 2,
  "c": 3,
  "d": 4,
  "e": 5,
  "f": 6,
  "g": 7,
  "h": 8,
  "i": 9,
  "j": 10,
  "k": 11,
  "l": 12,
  "m": 13,
  "n": 14,
  "o": 15,
  "p": 16,
  "q": 17,
  "r": 18,
  "s": 19,
  "t": 20,
  "u": 21,
  "v": 22,
  "w": 23,
  "x": 24,
  "y": 25,
  "z": 26,
  "A": 27,
  "B": 28,
  "C": 29,
  "D": 30,
  "E": 31,
  "F": 32,
  "G": 33,
  "H": 34,
  "I": 35,
  "J": 36,
  "K": 37,
  "L": 38,
  "M": 39,
  "N": 40,
  "O": 41,
  "P": 42,
  "Q": 43,
  "R": 44,
  "S": 45,
  "T": 46,
  "U": 47,
  "V": 48,
  "W": 49,
  "X": 50,
  "Y": 51,
  "Z": 52,
]

@main
struct ElfRockPaperScissors: ParsableCommand {
  @Argument(help: "input file to evaluate")
  var file: String

  mutating func run() throws {
    guard
      let data = String(data: try! Data(contentsOf: URL(fileURLWithPath: file)), encoding: .utf8)
    else {
      throw Errors.InvalidFile
    }
    
    let lines = data.split(whereSeparator: \.isNewline)

    var pointsPart1 = 0
    lines.forEach {
      let line = String($0)
      let middle = line.middleIndex
      let left = line[..<middle]
      let right = line[middle...]
      let intersect = Set(left).intersection(right).first!
      pointsPart1 = pointsPart1 + points[intersect]!
    }
    
    var pointsPart2 = 0
    lines.chunked(into: 3)
      .map { ($0[0], $0[1], $0[2]) }
      .forEach { lines in
        let (elf1, elf2, elf3) = lines
        
        // brute force - intersections :)
        let i1 = Set(elf1).intersection(elf2)
        let i2 = Set(elf1).intersection(elf3)
        let i3 = Set(elf2).intersection(elf3)
        let i4 = Set(i1).intersection(i2).intersection(i3).first!
        pointsPart2 = pointsPart2 + points[i4]!
      }

    print("part 1: \(pointsPart1)")
    print("part 2: \(pointsPart2)")
  }
}

enum Errors: Error {
  case InvalidFile
}

extension String {
  var middleIndex: String.Index {
    index(startIndex, offsetBy: count / 2)
  }

  subscript(bounds: PartialRangeUpTo<Int>) -> String {
    let start = index(startIndex, offsetBy: 0)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return String(self[start...end])
  }

  subscript(bounds: PartialRangeFrom<Int>) -> String {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: count - 1)
    return String(self[start...end])
  }
}

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0..<Swift.min($0 + size, count)])
    }
  }
}
