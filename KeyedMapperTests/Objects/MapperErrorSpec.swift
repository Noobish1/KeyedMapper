import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct Model: Mappable {
    fileprivate enum Key: String, JSONKey {
        case stringProperty
    }
    
    fileprivate let stringProperty: String
    
    fileprivate init(map: KeyedMapper<Model>) throws {
        try self.stringProperty = map.from(.stringProperty)
    }
}

class MapperErrorSpec: QuickSpec {
    override func spec() {
        describe("failureReason") {
            context("when the error is") {
                context("a customError") {
                    it("should return the message associated value") {
                        let expectedValue = "message"
                        let error = MapperError<Model>.customError(field: nil, message: expectedValue)
                        
                        expect(error.failureReason) == expectedValue
                    }
                }
                
                context("a invalidRawValueError") {
                    it("should return the correct message") {
                        let field: Model.Key = .stringProperty
                        let type = Model.self
                        let value = ""
                        let expectedType = NSDictionary.self
                        let expectedMessage = "Invalid raw value for field \(field) of type \(type), \"\(value)\" is not a valid rawValue of \(expectedType)"
                        let error = MapperError<Model>.invalidRawValueError(field: field, forType: type, value: value, expectedType: expectedType)
                        
                        expect(error.failureReason) == expectedMessage
                    }
                }
            }
        }
    }
}
