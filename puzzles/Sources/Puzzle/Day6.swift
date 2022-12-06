// swift run Puzzle day6
// sliding window problem
import ArgumentParser
import Foundation

struct Day6: ParsableCommand {
  @Argument(help: "input file to evaluate")
  var file: String = "inputs/day6-inputs.txt"

  mutating func run() throws {
    let input =
      "qzbzwwghwhwdhdqhhbhfbfsstggdsssgzgdzzdbbbzmbzzvlldppjnjlltwtsszwswgssjnsjnnfqfzqqjzjfjmfmwfmfhfnnmdnmnllbzzlbzlzflldzdbzbsbdddpgdppzhphhjjtccjgcgrgjgcjgjjsbjbffsgsqqrsqqgppgmgcmmrdrqdqbqmmctchcgcdgdwdwcdcjcfjccmpmlpllqqpmpllhfhchppwwdmdhdphpvprrhwhgwwlrwlwggwlwqqnmqnqrrbbzdzwddqzznllzwlljsscqqtlltppqspswsttlrttnvvvwllfslsjsfjssnqnbbbvgvlltjtltjljmljjfgfbggcbgbmbjjvwjvjgvgzvvzddrjdddrwrlrlgldlhlwwcddbsbbtwwcssrnndvvsbsnbsbmbnmngnpgpphfhzhshllltqtppnrrzpzrpzzrttmbmssbrbmbsmsnspnsncscwwmjwmwdmwmrmvmqvqvjqvvnrrtntwwwwsrwrnwnrwwwlslrlhrllvpvhppdpprrgzrgzggqmqgmgvghhsmhhjljfflrflfrlrzzbjjqmmmcncddvhhzjjqzzjfzzbssjqqtsqtqccmttdhttmwtmtffspplhlrhrdhhhpghgrhrchhmgmqgqlglssvnnwrrrrqqbmmpgmpmdmmljlflzzjttqntqqcnqccrvcczffclffmvfvwvmvnvsvnvffczzljzztdtztcztctbtppmrprqprpbbhlhphphhvppvdvmddvcctvvjbvvpmpbpnpllvclvlqlwqqpcpffdwdsdttzftfddbrrgsrgsgvgpgjpggfvgfvvtqtnnscssmnnfqnnblnnjlnlbbjrrmmpgmgnnqbbcjbcjbbmjjljsjrsjrsrwrgwgpgqgccqppfdpdssffgdgwddcvdvzzpttjlttmwwhnnlntncttfvfwvvwrvrwwlhlwlvwvzvpvfpvvsbslblrlssjddwhwfhwffqjfjzfjfmfrrvsrrlbrrdfdmdwmddpnpfnpfnfppczpprzprpvpjjtltptvvrgvvsttflfvfqqhnnbmnbmmpsptpdpttrbbhjbbdnntppbsbmssgccfdfflppbcpbblclrlhrhttffvqqvvnpnmpnnrbnnhqnqrrwvwrrbvbffcvctcjcwwmzmvvtdvtvbtblbvlbvlvdvdrdsrdrprllnzznzhhcjjsgglfglgrlrwwfcfzfjzfztfztzggffjftjffcbfbhhwfwnnbssrpsppmllszstztwwgbwgbgtbgggztgztzwtztbbrffznndhdmmqggssjfssrgssbnsndnqnvqvqvjqvqttlctltvlttrzrqrrdprddpqqvppvddgmdddpldllnvvjdjcjdjvvznzqqbgqbgbpbnbvvdjvvsnndsdjjjhnhggrnnrvrvlvqllqhhsbhssvvlhlssgqgmqqcscpsspsrpsrpspvvdmvdvwwcjwwvhwvvmzvzvfvccfzczjccscbcrcjrrrsgrsspnsntsnnrnwwhdwwzhzbbwgwcgglvlttqrttvrrgprrljlddnttqrqffgdfgdgzzhghthhmdmsmtsshhsfhhgzgvzgzwzffvlffzjjrttsdddbldljlvjvjttwdwzzrbblwbbgmbmgmbggbdbsbqqwzzgnzgzczpzfztftbtwbtbsttrwrfrssbrrdqdjqdqppdsswrwttmgmllqbqnnpspjjzjjmbbsddgjgbjggqqlgqgmgdmmwcmwcmwwsddvgvpphmhqmmlvlpvlpltllphhcshhrsrgsgzssspjspplgghvvwhwgwssbhshvvscshhbccbtcbcvvmnndsdwwbzbffhmmbppfjppbsblbtlltggzczdczdzjdjpjtppwdwlwqwnwjnnvttmcmzzqccvfcvvmrmzmwmhmttgdgmsrlddnbgqfbbmrpdglpbtdqpmctzjrffvvqnltcqlfddwqhvjpzhczzwhsmjtrpgsdtqlcqsljsjzqwhcfwttgghsjqhzqlgjzgrtgttwblpprbppcpzsbntrwwmvfvbmjjrjwjqcjhnstmvwzrbnjpzznnctrtllzhtwttntjqwjnfspzccqpjlzbncgbjjjztbgfmzflzsqflflcrfhtlsgbdfdbtwwqfdrqhzmmqdqthwzwqqqzddfvbwhnqwqtgwhtzlqqpwhcjhglcmmncvfcmqdwnzzmjbflwjrcjzwcblftzrpdcjzcmtzccjbsqmcnfmbsmrvlhswnmrqdczvvzzcnffgljdbtlvjgrqttcjhjmcdllnvhcdpztqghfgvjcqmqvmdwhcgrtwpjlmjfbqmnjnbvvjczcwfcrhcgzmsvmjlplcpghnqtpzddnwtmrwmqwbttsnlngszfbnslqvlbzbfzqnjpdvcdpmjpmmjhvzwwgzfjfqwbqwrznhsdpjgsvzlsrtlmhjrfnwrmljlqzwnfnsmqtzfsldwrgmbrrvcmmmdmwflwnvpwsrrstmffwbtwqmjzdnzbwmqfrfdgsmhzhprdsgsqtljqhtdqmvnzlwhrrqqftbvnhmjnzvmbdqpjhzjnszgcfptfcmthpfcvfvdmwdswzfgwjblglfbpfvvwrmnzlcvtgqbcrhfqlffrznnhbtbwdwdldthbhdsqvnghpqdlvpfmzhjbtdhfmrdzpghtppmvddnphcnnczvznwzrvtcwvpslhrhmhzbzqtjqjvdpwncjbqdnwwpnfblqtqdwwqncbvtsncfhgncrprvhvzppwjfpdmtdrmtfcqdmdhwzrhpnrvspfbzhsvlpwzgrrhnrllhmpcdfcqdhcnphlffpbfmbsznmvfdgshbsjcjjvhqqfpmjgpdpcrglbqdrnqmftqtnwcsgqzdwntfplsnlhdbdmcgwfldzzgmzjsdnldbnlnhjqhpmnsljsbhrglhjbbrmlhrmjnvzhnlvnfpdzfzwwdpzwhnqhlbqhrgfmvzpctdvscqbgznzdsvvvvcjnmbzlvsptslmqnggqjcmgvtgbnrzlmzqzmtdfvhjqqcpvbngmngjvrtcfvsmbvthvhmdcfhthmnjcvsvmsbwsjtmrwshspcsmnhvzqvglntngbmgtdngbvvcjrznpdmmsssljnnqjwwfzgwtlfqqpsqghjgrghldrcdmcqvqdjsfrfrnlnvltpfjhmcclwbsdcbmvmlnwltztfggzmrtnsczwvqgpqtwffmphprgrmjlnftlgqjvrngbcndlmrblmvcjsdhdcmtgsztjttpbgcznfcgdwfwdnqmrrjgdgrgshjfjqrbsjdhblvrqhlfphnbdslrjszcnpfhhwrfhhdvqbjpsmzznzbtbsgcggtctfbsrscvzlplfhlwjlrmzhbwjqhffdhrwcdctwvttwqzbdtrhdhdvtgvdbzjtqvdgbpwtzqqqnljztgpbjjcrgdgmrrsfvngcdbgzvcfpdppbgfrmmdnqdvtlwwglmghjwfjjrwjfnwgwdplbmlfljhsmshwvvvtdnvfcbbwplwnvzfcjwgsrrlctpsrhprttcjgcmfsjggfvbbljsbjtzplvjdwnwgsgvvntjwdwdqbwmtnnlgdcmfcccnwnrjlqtznjhdzwfpbzhjdmwwpcmffcwsnpfhmgqgwwnvpmqvrdfhlqtghrrbggdmtvpqgqsspmchnrqnrmqlddnspcdrwqpvclhrvjtzhpvthpltwqqbrdfjtnwncwrmdqszdpmmdzmjwjvqnfszvbchfdvwzhtrfgfhfmgwprdpqgmbfntsqztvqmtjvgbsjvzsbhfznbbzrstqbrrmqdjcztmfpnwbmvtccmvlhtvmgfdzcchbccrzznscbdwrdtnpslvcqmgrrvwhnjgjdpvbfgsdtdcmhpnwfwnnntqjqnwzfwnhsrjbhtqtlncvsnhgvtntfwldqfzztcdctsscfdmtnmdqgqgwmtqhlmswtqrvqbchdwtjsdlqjvfjdtmzlvrzwvfprzvjzrrfn"

    measure {
      let part1Result = partX_day6Puzzle(input: input, capacity: 4)
      print("part 1: \(part1Result)")
    }
    measure {
      let part1Result = partX_day6Puzzle(input: input, capacity: 14)
      print("part 2: \(part1Result)")
    }
  }
}

func partX_day6Puzzle(input: String, capacity: Int) -> Int {
  let lru = LRU(capacity: capacity)
  for (offset, char) in input.enumerated() {
    lru.set(key: char)
    if lru.cache.count == capacity {
      return offset + 1
    }
  }
  return -1
}

class LRU {
  let capacity: Int
  var cache = [Character: Int]()
  var queue = [Character]()

  init(capacity: Int) {
    self.capacity = capacity
  }

  func set(key: Character) {
    if queue.count == capacity {
      let first = queue.removeFirst()
      cache.decr(forKey: first)
    }
    queue.append(key)
    cache.incr(key: key)
  }
}

extension Dictionary where Key == Character, Value == Int {
  mutating func incr(key: Key) {
    if let value = self[key] {
      self[key] = value + 1
    } else {
      self[key] = 1
    }
  }

  mutating func decr(forKey key: Key) {
    if let value = self[key] {
      if value == 1 {
        self.removeValue(forKey: key)
      } else {
        self[key] = value - 1
      }
    }
  }
}
