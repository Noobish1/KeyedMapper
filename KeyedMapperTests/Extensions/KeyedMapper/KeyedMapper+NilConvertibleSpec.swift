import Foundation
import Quick
import Nimble
@testable import KeyedMapper

fileprivate enum NilConvertibleEnum: NilConvertible {
    case nothing
    case something

    fileprivate static func fromMap(_ value: Any?) throws -> NilConvertibleEnum {
        return value.map { _ in .something } ?? .nothing
    }
}

extension NilConvertibleEnum: Equatable {
    fileprivate static func == (lhs: NilConvertibleEnum, rhs: NilConvertibleEnum) -> Bool {
        switch lhs {
            case .nothing:
                switch rhs {
                    case .nothing: return true
                    case .something: return false
                }
            case .something:
                switch rhs {
                    case .nothing: return false
                    case .something: return true
                }
        }
    }
}

fileprivate struct Model: Mappable {
    fileprivate enum Key: String, JSONKey {
        case enumProperty
    }

    fileprivate let enumProperty: NilConvertibleEnum

    fileprivate init(map: KeyedMapper<Model>) throws {
        try self.enumProperty = map.from(.enumProperty)
    }
}

class KeyedMapper_NilConvertibleSpec: QuickSpec {
    override func spec() {
        describe("KeyedMapper+NilConvertible") {
            describe("from<T: NilConvertible>") {
                context("when the given JSON does not contain the value") {
                    it("should map correctly to the nothing case") {
                        let JSON: NSDictionary = [:]
                        let model = try! Model.from(dictionary: JSON)

                        expect(model.enumProperty) == NilConvertibleEnum.nothing
                    }
                }

                context("when the given JSON does contain the value") {
                    it("should map correctly to the something case") {
                        let JSON: NSDictionary = [Model.Key.enumProperty.stringValue : ""]
                        let model = try! Model.from(dictionary: JSON)

                        expect(model.enumProperty) == NilConvertibleEnum.something
                    }
                }
            }
        }
    }
}
