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

class KeyedMapperSpec: QuickSpec {
    override func spec() {
        describe("KeyedMapper") {
            describe("from<T>") {
                it("should use the given transform on the returned object") {
                    let transformedValue = "transformedValue"
                    let dict: NSDictionary = [ModelWithStringProperty.Key.stringProperty.stringValue : "notTheExpectedValue"]
                    let mapper = try! KeyedMapper(JSON: dict, type: ModelWithStringProperty.self)
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
