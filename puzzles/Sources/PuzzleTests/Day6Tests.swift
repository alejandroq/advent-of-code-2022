import XCTest

@testable import Puzzle

class Day6Tests: XCTestCase {
  func testCorrectUniqueCount() {
    let lru = LRU(capacity: 3)
    lru.set(key: "a")
    lru.set(key: "b")
    lru.set(key: "c")
    lru.set(key: "d")
    XCTAssert(lru.cache.count == 3)
    XCTAssert(lru.cache == ["b": 1, "c": 1, "d": 1])
  }

  func testShouldNotFind4UniqueCharacters() {
    let input = "qzbzwwghwhwdhdqhhbhfbfsstggdsssg"
    let lru = LRU(capacity: 4)
    for char in input {
      lru.set(key: char)
      if lru.cache.count == 4 {
        break
      }
    }
    XCTAssert(lru.cache.count == 2)
  }

  func testShouldFind4UniqueCharacters() {
    let input = "qzbzwwghwhwdhdqhhbhfbfsstgagdesssg"
    let lru = LRU(capacity: 4)
    for char in input {
      lru.set(key: char)
      if lru.cache.count == 4 {
        break
      }
    }
    XCTAssert(lru.cache.count == 4)
  }

  func testShouldFind4UniqueCharactersInLongString() {
    measure {
      let input =
        "lrdrgrcggjrgrddfqfqrqppptrtssnqqqlzqqslspppsddfnnwgnnwhhjttnsnswnnbqbrrcqrqdqcdddlnddwwlmmlmtmwmggjgjmmmrppqhhswhwhmhchtchhsttvbtvvpspjjqrrgqrqmqvmvzmvzzrnnqlnlwlttjstjtjvjddrzzrnrmrbmbwwzppnqpqmmjnnvqnvvdzdpdvvmhvhhmshmsssvnnqppclcqlcqctqtfffvrfvrffptfftppncncwnntfntftdftfhfzzfwzzcddngdndccrttjmmcddrvrwwnntggghccjbjvbvjvlvjlvlgljlnjjtvjjfddmwwhnnqnrnccwllpmprmmspsvsrsslstsllpmllfzlflqltlssdbbdsdqsdqqgfgfjjtzjzmmsnsmnnzssgfgzgjgwwqfqtfthhhczzpwprwwqttqcqctcpcrrvwrvrggfvfqvvbqqhnnczcjjjfbfhbhjhssnwwfswszwwgbgzgczcbbvmvrrdgrddfwdffvsvtstztftfvfssgffnrnnzzqddltdtbdttnnfrnnfrfddpmpqqplqqbdbzbnnnrttjfttprtrllqhhwjhjghjjcrcqqznztzllldjjhqqspsfpfprrsfspsrrzbbjmjssnjnsjnjllbttgrtrnnqhhvjhvvrrplrprtrtprtrdtdfttwdttqtttwvtvtmtntnnfvfsfnndsnnnfqfmmcdmdppsmpmnnwhhlwwrvwrwvwlwnwhwjwvwbvwvnnqtnnttcgtccbggzgwzwczcpzcpzpzgzngnzzhfhdhzzzsggtssddgtdtndtdllpbpjpgjjsllvqvmmvjmvjvbbfzzbdzzghhzjzvvnffwsshqhqhjhmmtgmgpmgmpmzzzhtzzbzsbzsbzszvsvgsvspvsstwtgwgqgjggsfsmffhlhmhdmhmgmrmffjcjggqgsghgttjffprpmmscsggswssgzzsqzqjqwqjwqwswjjqpjpllwrwffvfbfpbffjsswgsshjsjqssqrrvcrrnvvdnnwndnffpdffjlffrjrlrqrmmlzlttpccgchggdjjhwwvqvvrprdrttlvvtlvtlvvvhqhwhmmpmrrjsrrzbzfzdzhdzzwgwwqllmmthmmvpprqprrzmrrfrmfrrmfmjmwwhtwhttnbbhbnnhbnnmhmgmjgmgfmmhpplwplwlswwjjbpbhpbbzmmgjmmggbzbssppjtttfmfwwcwmmbmrmbrblbmmszzvgvzgvgvdggjgsjgsjgghfgfngffsnfssdpdgpgrgnrggrlggdwgdgddfwddjdrrppnnqbnntmmrmlmrrgvvqjjwzzgnzzdtzzbccnbcbttbzzcqqrcqqpspbphbphhnpnccggczcgcpgcpctppqwpwccsgsttgtbttvftfcfbfvfppfpnpffmjmljmmrtrsrttnhhcvctclttrffhzhrzzdpzzwvwddcggpbptbpbzpzdpzddbjjdvvwmmfvfcfmfmmvrmvrmmcdmdqqhjqhqmmstmmdnnvssmbsmmnhmnmlmttlthtvhvvgbvgvbvqbvbvnbvvpwwhwsszpszppjljsllzhzcchmhdhphvvtpvvfssvmvcmmrjmmgfmfwmfmsspbbpnnsbsgbbzzllzzsqqswqqsbqqlvqlqzzbrzzqsqdqjqzqlqccqbqlblpprrthrttjzzfvzzpvpbppqjpjjtllmrmzzwnnrggpfpllwhhnmnpmmdppwnnwpnnzlzggvpvgpprdrzddlmddjndjjrljlsjshhqbbhhmhvhqhzqqlbqlqnqqmhmwmhwwgbwbpbhpbblnnshnshslllrcrncctnthtllmglmlmnmfnfllrbrmdqsncjfbjnghmvpctfzttqwsfptwhfhmdhzgbmrpqvsbbwdwdnqgclrgvdbqvtnzvlzmdjzgbhbtqjhrgqqjgwcvpqhhwsmmflgsjsvbnjcjcqwqqfcbvfrllbpphfglptjfczmnfnrmqdgrhbvrddwvhnbffsnzntvldrwmgqmqdbmmpdjhpdqfsbzsfbtdzlfjwtwfpfrhzcwwrcfpdjzjzqvcnhvdvlbdbjfrnmchdjprbfpzdtmjhdjtrwfrsghngbswhfzdfvhdmnqwnpspdjgsfcjjhrlnpncfdhzfzglgvrjlzdcncbfjhpnrvwnqbzhtdfcnpnpddsnjcbgdvzlsmpnlbftgjfsjsslljppjhtjfddmwbtrvmhvshnvhhfdsqhpmgzfrcqtpdmfcwglnbjzmtmzshzsrnbzlwlzdjzzsqfmjzbnprjdzswwcgjjwslhnfhbflvcpdfzwhzzjmfvpfhzbrcdvtlmbvrqvvtlpbdnshtsvlcnlwqzcnfhzndfjbhgwpvspdvhfptnfvwznscmgthspwpjfwlbbcrzgthrhnvscvfvwrwvtzpjqmwdbjjslvzlmqstzwqtsdsqqjpqthgnshpjncwgvppngvvfrjpztftgjbbmgdddrcgjggwpfrvfqbnzvwtscftbwfssmrgrbchjmvqcdgbdmmsswvplnvnjrnqzhttbzhlthzjslgtgrnqpghtbjnbftpdttvqhrljhnfqllrhfmzcnnwrljmchsvdbgvwmrpfzjsbngpffpgntrgflntbjnjwqbdhvhssvptdvvqvtrgqhhzrcfnnmbtzqrcghggcqhndggqzzgswflhqqrgmnggbrvpwqgtlptgmzdvgztgfqdzwnbrvvqhpnmcmptqljmqqmsslfcmgpnmnjmrsngrtbsffqbwlhsrwbzdcqvpbptpjphcjnwsmrjdbbrwftsnrgfhpjvsjcwpmpvfjtjvfnnwdjdttsjrqrgsznzqwjmsvscdtpptmdhqvwngtldtsnstjmwwrwwzdzvtndrrhgsgshzlpdrmlsgvplvbfrffvgvhmncbjdlqspbpdpcdsffrjzptltsznwwqbvnrwfdtrlbbvsmzjrhhvscqfwsqtmwnpjfgnjcttwphtqqhnvgjmzvczcrlmjjgwgnprcmmprltfrgrjlhvggdwvpnrqrtfwhpsfnjfvmvgzpmhrqmggldmsvztwcwzgblfbvbfvnshrdppzcvjwbjmsncwnbnjwbmwqjjwtjmwzpdvpwrfdtrqhnltgntvglgspvnbcsvnpppwmgphhsdqtpmrzmbdqlghsgjnnbhflzwghzzhdfsvjjcjfcssmvrmfqbgzcfwmhpvjqqrrhpsffczwgbjgwqlvzrvnhvzrqnfllqtrcjhmpdjfpqnlzhdnsctbfhsbpgwqdjdjhfbqzvzpsgmqwfjsffdjcqfmjgzqzvfsbhhvnwlfjfmdnphggdbnmpznlrzbnlbvhvplhjbzdmspnnlbctgzphghpngppdpdfbcdcpfntqlrwclsvnpljdbwcbhwzzdhbhsmslvvtjsmqmtpnhmmqnhfggnlpfthdhpwmrhzgfpwsffnrdqszcttrjsqzjqgspltfzzjnzwdfzvnmncwnphmjvcwlgrzcvpzcbndvhtjnfsgjtjdqfmgcgtgppsrcqwdjcqfddlhhnlfjrnsnssqblmnjjvmfbghtwwgcpgzfddvzsrsghqfrpvdtqmjfrzpvclmsnpmrqngdwvznlhdpbrzqtswfhnblnnbwjcwwbwfrgcdgrpphnslgnwbtfcgcmvvllwgvrcrdfcfwvwmdhhzmmnzmjgmgrgpdhngjgmhlqwtgzlngrbbfwfjrpwbqjnvdggrcfdgphfctvbmjnwfbpwrvbdbjrbhtnhfvhwvrptptsdrnzmnlwgbrwcswrccwdftgvjnvhffghdvhltjwhppfwfnmmtwclzzftzwvmhpmgvdsqzrfwqsmcgswnzjcnrvdgjlqdjrczphsvldlfzwdwmpncpvgqsvgpfpsfbgbmdhnfqbhdqwwwfdgqtmjlfbztsrwjrtqnrfpfqgplznpftrnjzhzcrnngqpwbrpbhlbfsgrpwfflrpbqdrqdplgcn"
      let lru = LRU(capacity: 4)
      let pos = { () -> Int in
        for (offset, char) in input.enumerated() {
          lru.set(key: char)
          if lru.cache.count == 4 {
            return offset + 1
          }
        }
        return -1
      }()
      XCTAssert(lru.cache.count == 4)
      XCTAssert(pos == 1920, "pos: \(pos)")
    }
  }

  func testShouldFindMessage() {
    let capacity = 14
    let input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    let lru = LRU(capacity: capacity)
      let pos = { () -> Int in
        for (offset, char) in input.enumerated() {
          lru.set(key: char)
          if lru.cache.count == capacity {
            return offset + 1
          }
        }
        return -1
      }()
      XCTAssert(lru.cache.count == capacity)
      XCTAssert(pos == 19, "pos: \(pos)")
  }
}
