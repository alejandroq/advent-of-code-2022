//
//  Day11Tests.swift
//
//
//  Created by Alejandro Quesada on 12/10/22.
//

import XCTest

final class Day11Tests: XCTestCase {

  func testStringToMonkeys() throws {
    XCTAssertEqual(exampleInput.getMonkeys().count, 4)
  }

  //  These tests no longer work as `/ 3` is no longer used in "relief" analysis
  //  Kept for historical purposes.
  //
  //  func testMonkeyInspections() {
  //    XCTAssertEqual(day11_puzzle(input: exampleInput, rounds: 20), 10_605)
  //  }
  //
  //  func testPart1() {
  //    XCTAssertEqual(day11_puzzle(input: input, rounds: 20), 58_322)
  //  }

  func testPart2() {
    XCTAssertEqual(day11_puzzle(input: input, rounds: 10_000), 13_937_702_909)
  }

  /// Monkey <n>
  ///   Starting items: <worry level>[]
  ///   Operation: new = old x <v> (curr worry level x v = new worry level)
  ///   Test: divisible by <j>
  ///     If true: throw to monkey <id1>
  ///     if false: throw to monkey <id2>
  ///
  /// Note: Throw items one at a time
  let exampleInput = """
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
    """

  let input = String(
    data: try! Data(contentsOf: URL(fileURLWithPath: "inputs/day11-inputs.txt")),
    encoding: .utf8)!
}

func day11_puzzle(input: String, rounds: Int) -> Int {
  let monkeys = input.getMonkeys()
  let commonDivisor = monkeys.map { $0.value.eval.divisibleBy }.product()
  for _ in 1...rounds {
    for i in 0...(monkeys.count - 1) {
      monkeys[i]!.inspect(with: commonDivisor).forEach { outcome in
        monkeys[outcome.toMonkey]!.items.append(outcome.item)
      }
    }
  }
  // the monkey business!
  return monkeys.sorted { (lhs, rhs) in lhs.value.inspected > rhs.value.inspected }.prefix(2).map {
    $0.value.inspected
  }.product()
}

enum MonkeyOperator {
  case plus
  case multiply
}

enum MonkeyOperation {
  case int(_ int: Int, op: MonkeyOperator)
  case old(op: MonkeyOperator)
}

struct MonkeyEvaluation {
  var divisibleBy: Int
  var ifTrueThrowToMonkey: Int
  var ifFalseThrowToMonkey: Int
}

class Monkey: CustomStringConvertible {
  let id: Int
  var op: MonkeyOperation!
  var eval: MonkeyEvaluation!
  var items = [Int]()
  var inspected = 0

  var description: String {
    "Monkey(id: \(id), inspected: \(inspected))"
  }

  init(id: Int) {
    self.id = id
  }

  func inspect(with commonDivisor: Int) -> [(item: Int, toMonkey: Int)] {
    var outcomes = [(item: Int, toMonkey: Int)]()
    inspected = inspected + items.count
    while let item = items.popLast() {
      let newItem = {
        switch op! {
        case let .old(op: op):
          return (op == .multiply ? item * item : item + item) % commonDivisor
        case let .int(val, op: op):
          return (op == .multiply ? item * val : item + val) % commonDivisor
        }
      }()
      if newItem.isMultiple(of: eval.divisibleBy) {
        outcomes.append((item: newItem, toMonkey: eval.ifTrueThrowToMonkey))
      } else {
        outcomes.append((item: newItem, toMonkey: eval.ifFalseThrowToMonkey))
      }
    }
    return outcomes
  }
}

extension String {
  func getMonkeys() -> [Int: Monkey] {
    var monkeys = [Int: Monkey]()
    var iter = split(whereSeparator: \.isNewline).makeIterator()
    while let substring = iter.next() {
      var id: Int?
      if substring.contains("Monkey") {
        id = substring.digits.first
        let monkey = Monkey(id: id!)
        monkeys[id!] = monkey
        monkey.items = iter.next()!.digits
        monkey.op = iter.next()!.getMonkeyOperation()
        monkey.eval = MonkeyEvaluation(
          divisibleBy: iter.next()!.digits.first!, ifTrueThrowToMonkey: iter.next()!.digits.first!,
          ifFalseThrowToMonkey: iter.next()!.digits.first!)
      }
    }
    return monkeys
  }
}

extension String.SubSequence {
  var digits: [Int] {
    components(separatedBy: .decimalDigits.inverted)
      .filter { $0 != "" }
      .map { Int($0)! }
  }

  func getMonkeyOperation() -> MonkeyOperation {
    let s = components(separatedBy: " ").reversed()
    let op = try! { () throws -> MonkeyOperator in
      let match = s[s.index(s.startIndex, offsetBy: 1)]
      switch match {
      case "+": return .plus
      case "*": return .multiply
      default: throw "op \(match) is not available"
      }
    }()
    let n = s[s.index(s.startIndex, offsetBy: 0)]
    switch n {
    case "old": return .old(op: op)
    default: return .int(Int(n)!, op: op)
    }
  }
}
