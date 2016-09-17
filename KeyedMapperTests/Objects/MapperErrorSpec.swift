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
                        let error = MapperError.customError(field: nil, message: expectedValue)
                        
                        expect(error.failureReason) == expectedValue
                    }
                }
                
                context("a invalidRawValueError") {
                    it("should return the correct message") {
                        let field: Model.Key = .stringProperty
                        let type = Model.self
                        let value = ""
                        let expectedType = [AnyHashable : Any].self
                        let expectedMessage = "Invalid raw value for field \(field) of type \(type), \"\(value)\" is not a valid rawValue of \(expectedType)"
                        let error = MapperError.invalidRawValueError(field: field.stringValue, forType: type, value: value, expectedType: expectedType)
                        
                        expect(error.failureReason) == expectedMessage
                    }
                }
                
                context("a missingFieldError") {
                    it("should return the correct message") {
                        let field: Model.Key = .stringProperty
                        let type = Model.self
                        let expectedMessage = "Missing field \(field.stringValue) of type \(type)"
                        let error = MapperError.missingFieldError(field: field.stringValue, forType: type)
                        
                        expect(error.failureReason) == expectedMessage
                    }
                }
                
                context("a typeMismatchError") {
                    it("should return the correct message") {
                        let field: Model.Key = .stringProperty
                        let type = Model.self
                        let value = ""
                        let expectedType = [AnyHashable : Any].self
                        let expectedMessage = "Type mismatch for field \(field) of type \(type), \"\(value)\" is a \(type(of: value)) but is expected to be \(expectedType)"
                        let error = MapperError.typeMismatchError(field: field.stringValue, forType: type, value: value, expectedType: expectedType)
                        
                        expect(error.failureReason) == expectedMessage
                    }
                }
                
                context("a rootTypeMismatchError") {
                    it("should return the correct message") {
                        let type = Model.self
                        let value = ""
                        let expectedType = [AnyHashable : Any].self
                        let expectedMessage = "Type mismatch, root object \(value) of type \(type), expected to be of type \(expectedType)"
                        let error = MapperError.rootTypeMismatchError(forType: type, value: value, expectedType: expectedType)
                        
                        expect(error.failureReason) == expectedMessage
                    }
                }
                
                context("a convertibleError") {
                    it("should return the correct message") {
                        let value = ""
                        let expectedType = [AnyHashable : Any].self
                        let expectedMessage = "Could not convert \(value) to type \(expectedType)"
                        let error = MapperError.convertibleError(value: value, expectedType: expectedType)
                        
                        expect(error.failureReason) == expectedMessage
                    }
                }
            }
        }
    }
}
