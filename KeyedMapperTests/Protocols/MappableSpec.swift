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
            describe("from(dictionary:)") {
                it("should map correctly") {
                    let field = ModelWithStringProperty.Key.stringProperty
                    let dict: NSDictionary = [field.rawValue: "value"]
                    let model = try! ModelWithStringProperty.from(dictionary: dict)

                    expect(model).toNot(beNil())
                }
            }
        }
    }
}
