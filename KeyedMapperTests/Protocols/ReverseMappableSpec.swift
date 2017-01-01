import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct Model: Mappable, ReverseMappable {
    fileprivate enum Key: String, JSONKey {
        case stringProperty
    }

    fileprivate let stringProperty: String

    // MARK: Mappable
    fileprivate init(map: KeyedMapper<Model>) throws {
        try self.stringProperty = map.from(.stringProperty)
    }

    // MARK: ReverseMappable
    fileprivate func toKeyedJSON() -> [Key : Any?] {
        return [.stringProperty : stringProperty]
    }
}

extension Model: Equatable {
    fileprivate static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.stringProperty == rhs.stringProperty
    }
}

class ReverseMappableSpec: QuickSpec {
    override func spec() {
        describe("ReverseMappable") {
            describe("toJSON") {
                let field = Model.Key.stringProperty.stringValue

                it("should return an Dictionary that is identical to the one that was passed in originally") {
                    let expectedDict: NSDictionary = [field : ""]
                    let actualDict = try! Model.from(expectedDict).toJSON()

                    expect((actualDict as NSDictionary)) == (expectedDict as NSDictionary)
                }

                it("should return an Dictionary that can be used to recreate the same model") {
                    let expectedModel = try! Model.from([field : ""])
                    let actualModel = try! Model.from(expectedModel.toJSON())

                    expect(actualModel) == expectedModel
                }
            }
        }
    }
}
