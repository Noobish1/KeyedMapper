import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct ModelWithStringProperty: Mappable {
    fileprivate let stringProperty: String

    fileprivate enum Key: String, JSONKey {
        case stringProperty
    }

    fileprivate init(map: KeyedMapper<ModelWithStringProperty>) throws {
        try self.stringProperty = map.from(.stringProperty)
    }
}

extension ModelWithStringProperty: Equatable {
    fileprivate static func == (lhs: ModelWithStringProperty, rhs: ModelWithStringProperty) -> Bool {
        return lhs.stringProperty == rhs.stringProperty
    }
}

class MappableSpec: QuickSpec {
    override func spec() {
        describe("Mappable") {
            describe("from Array") {
                context("when the passed in array is not an array of Dictionaries") {
                    it("should throw a MapperError.rootTypeMismatch") {
                        let JSON: [Any] = [1]

                        do {
                            _ = try ModelWithStringProperty.from(array: JSON)
                        } catch let error as MapperError {
                            expect(error) == MapperError.rootTypeMismatch(forType: ModelWithStringProperty.self, value: JSON, expectedType: [NSDictionary].self)
                        } catch {
                            XCTFail("Error thrown from from(JSON: Array) was not a MapperError")
                        }
                    }
                }

                context("when the passed in array is an array of Dictionaries") {
                    it("should map the model correctly") {
                        let model = try! ModelWithStringProperty.from(dictionary: ["stringProperty": ""])
                        let models = try! ModelWithStringProperty.from(array: [["stringProperty": ""]])

                        expect(models) == [model]
                    }
                }
            }
        }
    }
}
