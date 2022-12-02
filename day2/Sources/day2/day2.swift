import ArgumentParser
import Foundation

@main
struct ElfRockPaperScissors: ParsableCommand {
  @Argument(help: "Input file to evaluate")
  var file: String

  mutating func run() throws {
    guard
      let data = String(data: try! Data(contentsOf: URL(fileURLWithPath: file)), encoding: .utf8)
    else {
      throw Errors.InvalidFile
    }

    var pointsPart1 = 0
    var pointsPart2 = 0

    data.enumerateLines { (line, _) in
      let moves = line.split(separator: " ")
      let l = LeftPlay.from(string: String(moves[0]))

      // MARK - part 1
      let _ = {
        let r = RightPlay.from(string: String(moves[1]))
        pointsPart1 = pointsPart1 + r.play(against: l)
      }()

      // MARK - part 2
      let _ = {
        let o = Outcome.from(string: String(moves[1]))
        let r = o.getRightPlay(against: l)
        pointsPart2 = pointsPart2 + r.play(against: l)
      }()
    }

    print("part 1 score: \(pointsPart1)")
    print("part 2 score: \(pointsPart2)")
  }
}

enum LeftPlay: String {
  case rock = "A"
  case paper = "B"
  case scissors = "C"
}

extension LeftPlay {
  func points() -> Int {
    switch self {
    case .rock:
      return 1
    case .paper:
      return 2
    case .scissors:
      return 3
    }
  }

  static func from(string: String) -> Self {
    return LeftPlay(rawValue: string)!
  }
}

enum RightPlay: String {
  case rock = "X"
  case paper = "Y"
  case scissors = "Z"
}

extension RightPlay {
  func points() -> Int {
    switch self {
    case .rock:
      return 1
    case .paper:
      return 2
    case .scissors:
      return 3
    }
  }

  @inlinable
  func play(against left: LeftPlay) -> Int {
    switch self {
    case .rock:
      switch left {
      case .rock: return Outcome.draw.points() + self.points()
      case .paper: return Outcome.lose.points() + self.points()
      case .scissors: return Outcome.win.points() + self.points()
      }
    case .paper:
      switch left {
      case .rock: return Outcome.win.points() + self.points()
      case .paper: return Outcome.draw.points() + self.points()
      case .scissors: return Outcome.lose.points() + self.points()
      }
    case .scissors:
      switch left {
      case .rock: return Outcome.lose.points() + self.points()
      case .paper: return Outcome.win.points() + self.points()
      case .scissors: return Outcome.draw.points() + self.points()
      }
    }
  }

  static func from(string: String) -> Self {
    return RightPlay(rawValue: string)!
  }
}

enum Outcome: String {
  case win = "Z"
  case draw = "Y"
  case lose = "X"
}

extension Outcome {
  func points() -> Int {
    switch self {
    case .win:
      return 6
    case .lose:
      return 0
    case .draw:
      return 3
    }
  }

  @inlinable
  func getRightPlay(against left: LeftPlay) -> RightPlay {
    switch self {
    case .win:
      switch left {
      case .rock: return RightPlay.paper
      case .paper: return RightPlay.scissors
      case .scissors: return RightPlay.rock
      }
    case .lose:
      switch left {
      case .rock: return RightPlay.scissors
      case .paper: return RightPlay.rock
      case .scissors: return RightPlay.paper
      }
    case .draw:
      switch left {
      case .rock: return RightPlay.rock
      case .paper: return RightPlay.paper
      case .scissors: return RightPlay.scissors
      }
    }
  }

  static func from(string: String) -> Self {
    return Outcome(rawValue: string)!
  }
}

enum Errors: Error {
  case InvalidFile
}
