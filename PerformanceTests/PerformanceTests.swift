import XCTest
import TestModels
import KeyedMapper

class KeyedMapper_Tests: XCTestCase {
    func testDeserialization() {
        self.measure {
            let d: NSDictionary = try! JSONSerialization.jsonObject(with: self.data, options: []) as! NSDictionary
            XCTAssert(d.count > 0)
        }
    }

    func testPerformance() {
        let json = try! JSONSerialization.jsonObject(with: self.data, options: [])

        self.measure {
            let programList = try! ProgramList.from(json)
            XCTAssert(programList.programs.count > 1000)
        }
    }

    private lazy var data:Data = {
        let path = Bundle(for: type(of: self)).url(forResource: "Large", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        return data
    }()
}
