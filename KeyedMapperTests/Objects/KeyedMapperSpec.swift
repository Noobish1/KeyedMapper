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
        case stringProperty
    }
    
    fileprivate init(map: KeyedMapper<ModelWithStringProperty>) throws {
        try self.stringProperty = map.from(.stringProperty)
    }
}

private struct ModelWithOptionalStringProperty: Mappable {
    fileprivate let stringProperty: String?
    
    fileprivate enum Key: String, JSONKey {
        case stringProperty
    }
    
    fileprivate init(map: KeyedMapper<ModelWithOptionalStringProperty>) throws {
        self.stringProperty = map.optionalFrom(.stringProperty)
    }
}

private struct ModelWithInnerModelProperty: Mappable {
    fileprivate let modelProperty: ModelWithStringProperty

    fileprivate enum Key: String, JSONKey {
        case modelProperty = "firstKey.secondKey"
    }

    fileprivate init(map: KeyedMapper<ModelWithInnerModelProperty>) throws {
        self.modelProperty = try map.from(.modelProperty)
    }
}

class KeyedMapperSpec: QuickSpec {
    override func spec() {
        describe("KeyedMapper") {
            describe("JSONFromField") {
                let field = ModelWithStringProperty.Key.stringProperty

                context("when given an empty string") {
                    it("should return the KeyedMapper's JSON") {
                        let dict: NSDictionary = [:]
                        let mapper = KeyedMapper(JSON: dict, type: ModelWithProperty.self)
                        let result = try! mapper.JSON(fromField: .property) as! NSDictionary
                        
                        expect((result as NSDictionary)) == (dict as NSDictionary)
                    }
                }
                
                context("when given a valid key") {
                    it("should return the value for that key") {
                        let expectedValue = "value"
                        let dict: NSDictionary = [field.stringValue : expectedValue]
                        let mapper = KeyedMapper(JSON: dict, type: ModelWithStringProperty.self)
                        let result = try! mapper.JSON(fromField: field) as! String
                        
                        expect(result) == expectedValue
                    }
                }
                
                context("when the json does not contain the value for the given key") {
                    it("should throw a missing field error") {
                        let dict: NSDictionary = [:]
                        let mapper = KeyedMapper(JSON: dict, type: ModelWithStringProperty.self)
                        
                        do {
                            try _ = mapper.JSON(fromField: field)
                        } catch let error as MapperError {
                            expect(error) == MapperError.missingField(field: field.stringValue, forType: ModelWithStringProperty.self)
                        } catch {
                            XCTFail("Error thrown from JSONFromField was not a MapperError")
                        }
                    }
                }
            }
            
            describe("safeValueForKeyPath(_:inDictionary:)") {
                context("when given an empty string") {
                    it("should return the entire dictionary") {
                        let dict: NSDictionary = ["key" : "value"]
                        let mapper = KeyedMapper(JSON: dict, type: ModelWithProperty.self)
                        let value = mapper.safeValue(forField: ModelWithProperty.Key.property, in: dict) as! NSDictionary
                        
                        expect((value as NSDictionary)) == (dict as NSDictionary)
                    }
                }
                
                context("when given an single key") {
                    let field = ModelWithStringProperty.Key.stringProperty

                    context("when the value exists for the given key") {
                        it("should return the value for the given key") {
                            let expectedValue = "value"
                            let dict: NSDictionary = [field.stringValue : expectedValue]
                            let mapper = KeyedMapper(JSON: dict, type: ModelWithStringProperty.self)
                            let value = mapper.safeValue(forField: field, in: dict) as! String
                            
                            expect(value) == expectedValue
                        }
                    }
                    
                    context("when the value does not exist for the given key") {
                        it("should return nil") {
                            let dict: NSDictionary = [:]
                            let mapper = KeyedMapper(JSON: dict, type: ModelWithStringProperty.self)
                            let value = mapper.safeValue(forField: field, in: dict) as? String
                            
                            expect(value).to(beNil())
                        }
                    }
                }

                context("when given a two part keypath") {
                    let keyPath = ModelWithInnerModelProperty.Key.modelProperty
                    let firstKey = String(keyPath.rawValue.characters.split(separator: ".").first!)

                    context("when the value exists for the given keypath") {
                        it("should return the value for the given keypath") {
                            let secondKey = String(keyPath.rawValue.characters.split(separator: ".")[1])
                            let expectedValue = "value"
                            let dict: NSDictionary = [firstKey : [secondKey : expectedValue]]
                            let mapper = KeyedMapper(JSON: dict, type: ModelWithInnerModelProperty.self)
                            let value = mapper.safeValue(forField: keyPath, in: dict) as! String
                            
                            expect(value) == expectedValue
                        }
                    }
                    
                    context("when the value does not exist for the given keypath") {
                        it("should return nil") {
                            let dict: NSDictionary = [firstKey : [:]]
                            let mapper = KeyedMapper(JSON: dict, type: ModelWithInnerModelProperty.self)
                            let value = mapper.safeValue(forField: keyPath, in: dict) as? String
                            
                            expect(value).to(beNil())
                        }
                    }
                }
            }
            
            describe("from<T>") {
                it("should use the given transform on the returned object") {
                    let transformedValue = "transformedValue"
                    let dict: NSDictionary = [ModelWithStringProperty.Key.stringProperty.stringValue : "notTheExpectedValue"]
                    let mapper = KeyedMapper(JSON: dict, type: ModelWithStringProperty.self)
                    let result = try! mapper.from(.stringProperty, transformation: { _ in transformedValue })
                    
                    expect(result) == transformedValue
                }
            }
            
            describe("optionalFrom<T>") {
                let field = ModelWithOptionalStringProperty.Key.stringProperty

                context("when the field does not exist in the given JSON") {
                    it("should return nil") {
                        let expectedValue = "notTheExpectedValue"
                        let dict: NSDictionary = [:]
                        let mapper = KeyedMapper(JSON: dict, type: ModelWithOptionalStringProperty.self)
                        let result = mapper.optionalFrom(field, transformation: { _ in expectedValue })
                        
                        expect(result).to(beNil())
                    }
                }
                
                context("when the field exists in the given JSON") {
                    it("should return the transformed value") {
                        let transformedValue = "transformedValue"
                        let dict: NSDictionary = [field.stringValue : "notTheExpectedValue"]
                        let mapper = KeyedMapper(JSON: dict, type: ModelWithOptionalStringProperty.self)
                        let result = mapper.optionalFrom(field, transformation: { _ in transformedValue })
                        
                        expect(result) == transformedValue
                    }
                }
            }
        }
    }
}
