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

class JSONSpec: QuickSpec {
    override func spec() {
        describe("KeyedMapper") {
            describe("JSONValue(fromField:)") {
                context("when given an empty string") {
                    it("should return the KeyedMapper's JSON") {
                        let modelType = ModelWithProperty.self
                        let field = modelType.Key.property.stringValue
                        let dict: NSDictionary = [:]
                        let json = try! JSON(value: dict, forObject: modelType)
                        let result: NSDictionary = try! json.value(fromField: field, forObject: modelType)

                        expect((result as NSDictionary)) == (dict as NSDictionary)
                    }
                }

                context("when given an single key") {
                    let modelType = ModelWithStringProperty.self
                    let field = modelType.Key.stringProperty

                    context("when the value exists for the given key") {
                        it("should return the value for the given key") {
                            let expectedValue = "value"
                            let dict: NSDictionary = [field.stringValue : expectedValue]
                            let json = try! JSON(value: dict, forObject: modelType)
                            let value: String = try! json.value(fromField: field.stringValue, forObject: modelType)

                            expect(value) == expectedValue
                        }
                    }

                    context("when the value does not exist for the given key") {
                        it("should return nil") {
                            let dict: NSDictionary = [:]
                            let json = try! JSON(value: dict, forObject: modelType)

                            do {
                                let _: String = try json.value(fromField: field.stringValue, forObject: modelType)
                            } catch let error as MapperError {
                                expect(error) == MapperError.missingField(field: field.stringValue, forType: modelType)
                            } catch {
                                XCTFail("Error thrown from KeyedMapper.JSONValue was not a MapperError")
                            }
                        }
                    }
                }

                context("when given a two part keypath") {
                    let modelType = ModelWithInnerModelProperty.self
                    let keyPath = modelType.Key.modelProperty
                    let firstKey = String(keyPath.rawValue.characters.split(separator: ".").first!)

                    context("when the value exists for the given keypath") {
                        it("should return the value for the given keypath") {
                            let secondKey = String(keyPath.rawValue.characters.split(separator: ".")[1])
                            let expectedValue = "value"
                            let dict: NSDictionary = [firstKey : [secondKey : expectedValue]]
                            let json = try! JSON(value: dict, forObject: modelType)
                            let value: String = try! json.value(fromField: keyPath.stringValue, forObject: modelType.self)

                            expect(value) == expectedValue
                        }
                    }

                    context("when the value does not exist for the given keypath") {
                        it("should return nil") {
                            let dict: NSDictionary = [firstKey : [:]]
                            let json = try! JSON(value: dict, forObject: modelType)

                            do {
                                let _: String = try json.value(fromField: keyPath.stringValue, forObject: modelType)
                            } catch let error as MapperError {
                                expect(error) == MapperError.missingField(field: keyPath.stringValue, forType: modelType)
                            } catch {
                                XCTFail("Error thrown from KeyedMapper.JSONValue was not a MapperError")
                            }
                        }
                    }
                }

                context("when the retrived value cannot be cast correctly") {
                    let modelType = ModelWithStringProperty.self
                    let field = modelType.Key.stringProperty

                    it("should return a typeMismatch error") {
                        let value: NSArray = []
                        let dict: NSDictionary = [field.stringValue : value]
                        let json = try! JSON(value: dict, forObject: modelType)

                        do {
                            let _: String = try json.value(fromField: field.stringValue, forObject: modelType.self)
                        } catch let error as MapperError {
                            expect(error) == MapperError.typeMismatch(field: field.stringValue, forType: modelType.self, value: value, expectedType: String.self)
                        } catch {
                            XCTFail("Error thrown from KeyedMapper.JSONValue was not a MapperError")
                        }
                    }
                }
            }
        }
    }
}
