import Quick
import Nimble
@testable import KeyedMapper

private struct ModelWithProperty: Mappable {
    fileprivate let property: NSDictionary
    
    fileprivate enum Key: String, JSONKey {
        case property = ""
    }
    
    fileprivate init(map: KeyedMapper<ModelWithProperty>) throws {
        try self.property = map.from(.property)
    }
}

private struct ModelWithStringProperty: Mappable {
    fileprivate let stringProperty: String
    
    fileprivate enum Key: String, JSONKey {
        case stringProperty = "stringProperty"
    }
    
    fileprivate init(map: KeyedMapper<ModelWithStringProperty>) throws {
        try self.stringProperty = map.from(.stringProperty)
    }
}

class KeyedMapperSpec: QuickSpec {
    override func spec() {
        describe("KeyedMapper") {
            describe("JSONFromField") {
                context("when given an empty string") {
                    it("should return the KeyedMapper's JSON") {
                        let dict: NSDictionary = [:]
                        let mapper = KeyedMapper<ModelWithProperty>(JSON: dict, type: ModelWithProperty.self)
                        let result = try! mapper.JSONFromField(.property) as! NSDictionary
                        
                        expect(result) == dict
                    }
                }
                
                context("when given a valid key") {
                    it("should return the value for that key") {
                        let expectedValue = "value"
                        let dict: NSDictionary = ["stringProperty" : expectedValue]
                        let mapper = KeyedMapper<ModelWithStringProperty>(JSON: dict, type: ModelWithStringProperty.self)
                        let result = try! mapper.JSONFromField(.stringProperty) as! String
                        
                        expect(result) == expectedValue
                    }
                }
                
                context("when the json does not contain the value for the given key") {
                    it("should throw a missing field error") {
                        let dict: NSDictionary = [:]
                        let mapper = KeyedMapper<ModelWithStringProperty>(JSON: dict, type: ModelWithStringProperty.self)
                        
                        do {
                            try _ = mapper.JSONFromField(.stringProperty)
                        } catch let error as MapperError<ModelWithStringProperty> {
                            expect(error) == MapperError.missingFieldError(field: .stringProperty, forType: ModelWithStringProperty.self)
                        } catch {
                            XCTFail("Error thrown from JSONFromField was not a MapperError")
                        }
                    }
                }
            }
        }
    }
}
