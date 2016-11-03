import Quick
import Nimble
@testable import KeyedMapper

class DefaultConvertibleSpec: QuickSpec {
    override func spec() {
        describe("DefaultConvertible") {
            describe("fromMap") {
                context("when the given value cannot be cast to the ConvertedType") {
                    it("should throw a convertible error") {
                        let value = "" as AnyObject
                        let type = Int.self
                        
                        do {
                            _ = try type.fromMap(value)
                        } catch let error as MapperError {
                            expect(error) == MapperError.convertible(value: value, expectedType: type)
                        } catch {
                            XCTFail("Error thrown from DefaultConvertible.fromMap was not a MapperError")
                        }
                    }
                }
                
                context("when the given value can be cast to the ConvertedType") {
                    it("should return the converted object") {
                        let expectedValue = 1
                        let actualValue = try! Int.fromMap(expectedValue as AnyObject)
                        
                        expect(actualValue) == expectedValue
                    }
                }
            }
        }
    }
}
