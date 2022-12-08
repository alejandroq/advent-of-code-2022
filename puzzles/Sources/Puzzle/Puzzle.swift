import ArgumentParser
import Foundation

@main
struct Puzzles: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Advent of Code 2022 puzzles",
    subcommands: [Day4.self, Day5.self, Day6.self, Day6S.self, Day7.self, Day8.self]
  )
}

enum Errors: Error {
  case InvalidFile
}
