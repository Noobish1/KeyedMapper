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

class Sequence_MappableSpec: QuickSpec {
    override func spec() {
        describe("Sequence<Mappable>.fromMap") {
            it("should correctly map an array of mappable objects") {
                let sequence: [NSDictionary] = [[Model.Key.stringProperty.rawValue : ""]]
                let models = try! [Model].fromMap(sequence)

                expect(models.count) == sequence.count
            }
        }

        describe("Sequence<Sequence<Mappable>>.fromMap") {
            it("should correctly map a two dimensional array of mappable objects") {
                let sequence: [[NSDictionary]] = [[[Model.Key.stringProperty.rawValue : ""]]]
                let models = try! [[Model]].fromMap(sequence)

                expect(models.count) == sequence.count
            }
        }
    }
}
