import Algorithms
// swift run Puzzle day6-s
// sliding window problem
import ArgumentParser
import Foundation

struct Day6S: ParsableCommand {
  @Argument(help: "input file to evaluate")
  var file: String = "inputs/day6-inputs.txt"

  mutating func run() throws {
    let input =
      "qzbzwwghwhwdhdqhhbhfbfsstggdsssgzgdzzdbbbzmbzzvlldppjnjlltwtsszwswgssjnsjnnfqfzqqjzjfjmfmwfmfhfnnmdnmnllbzzlbzlzflldzdbzbsbdddpgdppzhphhjjtccjgcgrgjgcjgjjsbjbffsgsqqrsqqgppgmgcmmrdrqdqbqmmctchcgcdgdwdwcdcjcfjccmpmlpllqqpmpllhfhchppwwdmdhdphpvprrhwhgwwlrwlwggwlwqqnmqnqrrbbzdzwddqzznllzwlljsscqqtlltppqspswsttlrttnvvvwllfslsjsfjssnqnbbbvgvlltjtltjljmljjfgfbggcbgbmbjjvwjvjgvgzvvzddrjdddrwrlrlgldlhlwwcddbsbbtwwcssrnndvvsbsnbsbmbnmngnpgpphfhzhshllltqtppnrrzpzrpzzrttmbmssbrbmbsmsnspnsncscwwmjwmwdmwmrmvmqvqvjqvvnrrtntwwwwsrwrnwnrwwwlslrlhrllvpvhppdpprrgzrgzggqmqgmgvghhsmhhjljfflrflfrlrzzbjjqmmmcncddvhhzjjqzzjfzzbssjqqtsqtqccmttdhttmwtmtffspplhlrhrdhhhpghgrhrchhmgmqgqlglssvnnwrrrrqqbmmpgmpmdmmljlflzzjttqntqqcnqccrvcczffclffmvfvwvmvnvsvnvffczzljzztdtztcztctbtppmrprqprpbbhlhphphhvppvdvmddvcctvvjbvvpmpbpnpllvclvlqlwqqpcpffdwdsdttzftfddbrrgsrgsgvgpgjpggfvgfvvtqtnnscssmnnfqnnblnnjlnlbbjrrmmpgmgnnqbbcjbcjbbmjjljsjrsjrsrwrgwgpgqgccqppfdpdssffgdgwddcvdvzzpttjlttmwwhnnlntncttfvfwvvwrvrwwlhlwlvwvzvpvfpvvsbslblrlssjddwhwfhwffqjfjzfjfmfrrvsrrlbrrdfdmdwmddpnpfnpfnfppczpprzprpvpjjtltptvvrgvvsttflfvfqqhnnbmnbmmpsptpdpttrbbhjbbdnntppbsbmssgccfdfflppbcpbblclrlhrhttffvqqvvnpnmpnnrbnnhqnqrrwvwrrbvbffcvctcjcwwmzmvvtdvtvbtblbvlbvlvdvdrdsrdrprllnzznzhhcjjsgglfglgrlrwwfcfzfjzfztfztzggffjftjffcbfbhhwfwnnbssrpsppmllszstztwwgbwgbgtbgggztgztzwtztbbrffznndhdmmqggssjfssrgssbnsndnqnvqvqvjqvqttlctltvlttrzrqrrdprddpqqvppvddgmdddpldllnvvjdjcjdjvvznzqqbgqbgbpbnbvvdjvvsnndsdjjjhnhggrnnrvrvlvqllqhhsbhssvvlhlssgqgmqqcscpsspsrpsrpspvvdmvdvwwcjwwvhwvvmzvzvfvccfzczjccscbcrcjrrrsgrsspnsntsnnrnwwhdwwzhzbbwgwcgglvlttqrttvrrgprrljlddnttqrqffgdfgdgzzhghthhmdmsmtsshhsfhhgzgvzgzwzffvlffzjjrttsdddbldljlvjvjttwdwzzrbblwbbgmbmgmbggbdbsbqqwzzgnzgzczpzfztftbtwbtbsttrwrfrssbrrdqdjqdqppdsswrwttmgmllqbqnnpspjjzjjmbbsddgjgbjggqqlgqgmgdmmwcmwcmwwsddvgvpphmhqmmlvlpvlpltllphhcshhrsrgsgzssspjspplgghvvwhwgwssbhshvvscshhbccbtcbcvvmnndsdwwbzbffhmmbppfjppbsblbtlltggzczdczdzjdjpjtppwdwlwqwnwjnnvttmcmzzqccvfcvvmrmzmwmhmttgdgmsrlddnbgqfbbmrpdglpbtdqpmctzjrffvvqnltcqlfddwqhvjpzhczzwhsmjtrpgsdtqlcqsljsjzqwhcfwttgghsjqhzqlgjzgrtgttwblpprbppcpzsbntrwwmvfvbmjjrjwjqcjhnstmvwzrbnjpzznnctrtllzhtwttntjqwjnfspzccqpjlzbncgbjjjztbgfmzflzsqflflcrfhtlsgbdfdbtwwqfdrqhzmmqdqthwzwqqqzddfvbwhnqwqtgwhtzlqqpwhcjhglcmmncvfcmqdwnzzmjbflwjrcjzwcblftzrpdcjzcmtzccjbsqmcnfmbsmrvlhswnmrqdczvvzzcnffgljdbtlvjgrqttcjhjmcdllnvhcdpztqghfgvjcqmqvmdwhcgrtwpjlmjfbqmnjnbvvjczcwfcrhcgzmsvmjlplcpghnqtpzddnwtmrwmqwbttsnlngszfbnslqvlbzbfzqnjpdvcdpmjpmmjhvzwwgzfjfqwbqwrznhsdpjgsvzlsrtlmhjrfnwrmljlqzwnfnsmqtzfsldwrgmbrrvcmmmdmwflwnvpwsrrstmffwbtwqmjzdnzbwmqfrfdgsmhzhprdsgsqtljqhtdqmvnzlwhrrqqftbvnhmjnzvmbdqpjhzjnszgcfptfcmthpfcvfvdmwdswzfgwjblglfbpfvvwrmnzlcvtgqbcrhfqlffrznnhbtbwdwdldthbhdsqvnghpqdlvpfmzhjbtdhfmrdzpghtppmvddnphcnnczvznwzrvtcwvpslhrhmhzbzqtjqjvdpwncjbqdnwwpnfblqtqdwwqncbvtsncfhgncrprvhvzppwjfpdmtdrmtfcqdmdhwzrhpnrvspfbzhsvlpwzgrrhnrllhmpcdfcqdhcnphlffpbfmbsznmvfdgshbsjcjjvhqqfpmjgpdpcrglbqdrnqmftqtnwcsgqzdwntfplsnlhdbdmcgwfldzzgmzjsdnldbnlnhjqhpmnsljsbhrglhjbbrmlhrmjnvzhnlvnfpdzfzwwdpzwhnqhlbqhrgfmvzpctdvscqbgznzdsvvvvcjnmbzlvsptslmqnggqjcmgvtgbnrzlmzqzmtdfvhjqqcpvbngmngjvrtcfvsmbvthvhmdcfhthmnjcvsvmsbwsjtmrwshspcsmnhvzqvglntngbmgtdngbvvcjrznpdmmsssljnnqjwwfzgwtlfqqpsqghjgrghldrcdmcqvqdjsfrfrnlnvltpfjhmcclwbsdcbmvmlnwltztfggzmrtnsczwvqgpqtwffmphprgrmjlnftlgqjvrngbcndlmrblmvcjsdhdcmtgsztjttpbgcznfcgdwfwdnqmrrjgdgrgshjfjqrbsjdhblvrqhlfphnbdslrjszcnpfhhwrfhhdvqbjpsmzznzbtbsgcggtctfbsrscvzlplfhlwjlrmzhbwjqhffdhrwcdctwvttwqzbdtrhdhdvtgvdbzjtqvdgbpwtzqqqnljztgpbjjcrgdgmrrsfvngcdbgzvcfpdppbgfrmmdnqdvtlwwglmghjwfjjrwjfnwgwdplbmlfljhsmshwvvvtdnvfcbbwplwnvzfcjwgsrrlctpsrhprttcjgcmfsjggfvbbljsbjtzplvjdwnwgsgvvntjwdwdqbwmtnnlgdcmfcccnwnrjlqtznjhdzwfpbzhjdmwwpcmffcwsnpfhmgqgwwnvpmqvrdfhlqtghrrbggdmtvpqgqsspmchnrqnrmqlddnspcdrwqpvclhrvjtzhpvthpltwqqbrdfjtnwncwrmdqszdpmmdzmjwjvqnfszvbchfdvwzhtrfgfhfmgwprdpqgmbfntsqztvqmtjvgbsjvzsbhfznbbzrstqbrrmqdjcztmfpnwbmvtccmvlhtvmgfdzcchbccrzznscbdwrdtnpslvcqmgrrvwhnjgjdpvbfgsdtdcmhpnwfwnnntqjqnwzfwnhsrjbhtqtlncvsnhgvtntfwldqfzztcdctsscfdmtnmdqgqgwmtqhlmswtqrvqbchdwtjsdlqjvfjdtmzlvrzwvfprzvjzrrfn"

    measure {
      let part1Result = partX_day6sPuzzle(input: input, count: 4)
      print("part 1: \(part1Result)")
    }
    measure {
      let part1Result = partX_day6sPuzzle(input: input, count: 14)
      print("part 2: \(part1Result)")
    }
  }
}

func partX_day6sPuzzle(input: String, count: Int) -> Int {
  for (offset, window) in input.windows(ofCount: count).enumerated() {
    let windowSet = Set(window)
    if windowSet.count == count {
      return offset + count + 1
    }
  }
  return -1
}
