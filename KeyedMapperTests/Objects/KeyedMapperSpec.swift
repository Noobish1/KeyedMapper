import Quick
import Nimble
@testable import KeyedMapper

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

fileprivate struct ModelWithArrayProperty: Mappable {
    fileprivate enum Key: String, JSONKey {
        case arrayMappableProperty
    }

    fileprivate let arrayMappableProperty: [ModelWithStringProperty]

    fileprivate init(map: KeyedMapper<ModelWithArrayProperty>) throws {
        try self.arrayMappableProperty = map.from(.arrayMappableProperty)
    }
}

fileprivate struct ModelWithTwoDArrayProperty: Mappable {
    fileprivate enum Key: String, JSONKey {
        case twoDArrayMappableProperty
    }

    fileprivate let twoDArrayMappableProperty: [[ModelWithStringProperty]]

    fileprivate init(map: KeyedMapper<ModelWithTwoDArrayProperty>) throws {
        try self.twoDArrayMappableProperty = map.from(.twoDArrayMappableProperty)
    }
}

class KeyedMapperSpec: QuickSpec {
    override func spec() {
        describe("KeyedMapper") {
            describe("from returning T") {
                it("should use the given transform on the returned object") {
                    let transformedValue = "transformedValue"
                    let dict: NSDictionary = [ModelWithStringProperty.Key.stringProperty.stringValue : "notTheExpectedValue"]
                    let mapper = try! KeyedMapper(JSON: dict, type: ModelWithStringProperty.self)
                    let result = try! mapper.from(.stringProperty, transformation: { _ in transformedValue })

                    expect(result) == transformedValue
                }
            }

            describe("from returning array of T") {
                it("should use the given transform on the returned object") {
                    let transformedValue = ["transformedValue"]
                    let dict: NSDictionary = [ModelWithArrayProperty.Key.arrayMappableProperty.stringValue : ["notTheExpectedValue"]]
                    let mapper = try! KeyedMapper(JSON: dict, type: ModelWithArrayProperty.self)
                    let result: [String] = try! mapper.from(.arrayMappableProperty, transformation: { _ in transformedValue })

                    expect(result) == transformedValue
                }
            }

            describe("from returning two dimensional array of T") {
                it("should use the given transform on the returned object") {
                    let modelType = ModelWithTwoDArrayProperty.self
                    let field = modelType.Key.twoDArrayMappableProperty
                    let transformedValue = [["transformedValue"]]
                    let dict: NSDictionary = [field.stringValue : [["notTheExpectedValue"]]]
                    let mapper = try! KeyedMapper(JSON: dict, type: modelType.self)
                    let result: [[String]] = try! mapper.from(field, transformation: { (_: [[Any]]) -> [[String]] in
                        transformedValue
                    })

                    expect(result == transformedValue).to(beTrue())
                }
            }

            describe("optionalFrom returning optional T") {
                let field = ModelWithOptionalStringProperty.Key.stringProperty

                context("when the field does not exist in the given JSON") {
                    it("should return nil") {
                        let expectedValue = "notTheExpectedValue"
                        let dict: NSDictionary = [:]
                        let mapper = try! KeyedMapper(JSON: dict, type: ModelWithOptionalStringProperty.self)
                        let result = mapper.optionalFrom(field, transformation: { _ in expectedValue })

                        expect(result).to(beNil())
                    }
                }

                context("when the field exists in the given JSON") {
                    it("should return the transformed value") {
                        let transformedValue = "transformedValue"
                        let dict: NSDictionary = [field.stringValue : "notTheExpectedValue"]
                        let mapper = try! KeyedMapper(JSON: dict, type: ModelWithOptionalStringProperty.self)
                        let result = mapper.optionalFrom(field, transformation: { _ in transformedValue })

                        expect(result) == transformedValue
                    }
                }
            }
        }
    }
}

fileprivate func == (lhs: [[String]], rhs: [[String]]) -> Bool {
    return lhs.flatMap { $0 } == rhs.flatMap { $0 }
}
