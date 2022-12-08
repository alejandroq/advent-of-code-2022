import XCTest

@testable import Puzzle

class Day7Tests: XCTestCase {
  func testCreateCdCommand() {
    XCTAssert("$ cd ..".toCommand() == .cd(input: ".."))
  }

  func testCreateLsCommand() {
    XCTAssert("$ ls".toCommand() == .ls)
  }

  func testCreateDir() {
    XCTAssert("dir foobar".toKind() == .dir(name: "foobar"))
  }

  func testCreateFile() {
    XCTAssert("100 foobar".toKind() == .file(name: "foobar", bytes: 100))
  }

  func testIsCommand() {
    XCTAssert("$ ls".isCommand())
    XCTAssert(!"100 foobar".isCommand())
  }

  func testNodeNamespace() {
    let got = Node(kind: .dir(name: "abc"), parent: nil)
      .add(kind: .file(name: "def", bytes: 10))
      .getPath()
    XCTAssert(got == "abc/def", "got == \(got)")
  }

  func testExample() {
    let inputs = """
      $ ls
      dir a
      14848514 b.txt
      8504156 c.dat
      dir d
      $ cd a
      $ ls
      dir e
      29116 f
      2557 g
      62596 h.lst
      $ cd e
      $ ls
      584 i
      $ cd ..
      $ cd ..
      $ cd d
      $ ls
      4060174 j
      8033020 d.log
      5626152 d.ext
      7214296 k
      $ cd d
      $ ls
      """.split(whereSeparator: \.isNewline).map { String($0) }

    let root = collect(inputs: inputs)

    let contents = root.getContents()

    XCTAssert(contents.dict["//a/e"] == 584, "//a/e == \(contents.dict["//a/e"] ?? -1)")
    XCTAssert(contents.dict["//a"] == 94_853, "//a == \(contents.dict["//a"] ?? -1)")
    XCTAssert(contents.dict["//d"] == 24_933_642, "//d == \(contents.dict["//d"] ?? -1)")
    XCTAssert(contents.dict["//d/d"] == 0, "//d/d == \(contents.dict["//d/d"] ?? -1)")
  }

  func testContentsCorrectness() throws {
    guard
      let data = String(
        data: try! Data(contentsOf: URL(fileURLWithPath: "inputs/day7-inputs.txt")), encoding: .utf8
      )
    else {
      throw Errors.InvalidFile
    }

    let inputs = data.split(whereSeparator: \.isNewline).map { String($0) }

    let root = collect(inputs: inputs)

    let contents = root.getContents()

    XCTAssert(contents.dict["ffpzc"] == 385_570, "ffpzc == \(contents.dict["ffpzc"]!)")
  }
}
