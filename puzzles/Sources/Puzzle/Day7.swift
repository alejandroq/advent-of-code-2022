// swift run Puzzle day7
import ArgumentParser
import Foundation

struct Day7: ParsableCommand {
  @Argument(help: "input file to evaluate")
  var file: String = "inputs/day7-inputs.txt"

  mutating func run() throws {
    guard
      let data = String(data: try! Data(contentsOf: URL(fileURLWithPath: file)), encoding: .utf8)
    else {
      throw Errors.InvalidFile
    }

    let inputs = data.split(whereSeparator: \.isNewline).map { String($0) }
    
    let root = collect(inputs: inputs)

    measure {
      print("part 1: \(part1_day7Puzzle(root: root))")
    }
    
    measure {
      print("part 2: \(part2_day7Puzzle(root: root))")
    }
  }
}

func collect(inputs: [String]) -> Node {
  let root = Node(kind: .dir(name: "/"), parent: nil)
  var head = root
  var iter = inputs.makeIterator()
  var command: Command? = iter.next()?.toCommand()

  while command != nil {
    switch command {
    case let .cd(input: input):
      if input == ".." {
        head = head.parent!
      } else {
        head = head.add(kind: .dir(name: input))
      }
      command = iter.next()?.toCommand()

    case .ls:
      var line = iter.next()
      if line == nil || line!.isCommand() {
        command = line?.toCommand()
        break
      }
      while line != nil {
        if line!.isCommand() {
          command = line?.toCommand()
          break
        }
        head.add(kind: line!.toKind())
        line = iter.next()
      }

    default: break
    }
  }

  return root
}

func part1_day7Puzzle(root: Node) -> Int {
  let contents = root.getContents()
  return contents.dict
    .filter { (key, value) in
      return value <= 100_000
    }
    .map { $0.value }
    .reduce(0) { (agg, value) in
      return agg + value
    }
}

func part2_day7Puzzle(root: Node) -> Int {
  let contents = root.getContents()
  let totalDisk = 70_000_000
  let requiredDisk = 30_000_000
  let currentTotal = contents.size
  let delta = abs(totalDisk - requiredDisk - currentTotal)
  
  return contents.dict
    .filter { (key, value) in
      return value > delta
    }
    .map { $0.value }
    .min()!
}

struct Contents {
  var size: Int
  var dict: [String: Int]
}

class Node {
  var kind: Kind
  var children: [Node] = []
  var parent: Node?

  init(kind: Kind, parent: Node?) {
    self.kind = kind
    self.parent = parent
  }

  @discardableResult
  func add(kind: Kind) -> Node {
    let node = Node(kind: kind, parent: self)
    children.append(node)
    return node
  }
}

extension Node {
  var name: String { kind.name }

  func getPath() -> String {
    var head: Node? = self
    var names = [String]()
    while head != nil {
      names.append(head!.name)
      head = head?.parent
    }
    return String(names.reversed().joined(by: "/"))
  }

  func getContents() -> Contents {
    var contents = Contents(size: 0, dict: [:])
    for child in children {
      switch child.kind {
      case let .file(name: _, bytes: bytes): contents.size = contents.size + bytes
      case .dir:
        let nested = child.getContents()
        contents.size = contents.size + nested.size
        contents.dict = contents.dict.merging(nested.dict, uniquingKeysWith: { _, new in new })
        contents.dict[child.getPath()] = nested.size
      }
    }
    return contents
  }
}

enum Command: Equatable {
  case cd(input: String)
  case ls
}

enum Kind: Equatable {
  case dir(name: String)
  case file(name: String, bytes: Int)
}

extension Kind {
  var name: String {
    switch self {
    case let .dir(name: name): return name
    case let .file(name: name, bytes: _): return name
    }
  }
}

extension String {
  func isCommand() -> Bool {
    self.split(separator: " ")[0] == "$"
  }

  func toCommand() -> Command {
    let tokens = self.split(separator: " ").triple()
    switch tokens {
    case let ("$", "cd", input): return .cd(input: String(input!))
    case ("$", "ls", nil): return .ls
    default: fatalError("invalid comand")
    }
  }

  func toKind() -> Kind {
    let tokens = self.split(separator: " ").pair()
    switch tokens {
    case let ("dir", name): return .dir(name: String(name))
    case let (bytes, name): return .file(name: String(name), bytes: Int(bytes)!)
    }
  }
}

extension Array where Element == Substring {
  fileprivate func triple() -> (Substring, Substring, Substring?) {
    if count == 3 {
      return (self[0], self[1], self[2])
    }
    if count == 2 {
      return (self[0], self[1], nil)
    }
    fatalError("array was not a triple or a pair")
  }

  fileprivate func pair() -> (Substring, Substring) {
    if count == 2 {
      return (self[0], self[1])
    }
    fatalError("array was not a pair")
  }
}

extension Array where Element == Int {
  func sum() -> Int {
    self.reduce(0) { $0 + $1 }
  }
}
