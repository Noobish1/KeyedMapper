import Quick
import Nimble
@testable import KeyedMapper

class ConvertibleErrorSpec: QuickSpec {
    override func spec() {
        describe("failureReason") {
            it("should return the correct message") {
                let value: String? = "value"
                let type = String.self
                let error = ConvertibleError(value: value, type: type)
                let expectedMessage = "Could not convert \(value) to type \(type)"
                
                expect(error.failureReason) == expectedMessage
            }
        }
    }
}
