import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct ConvertibleObject: Convertible {
    fileprivate let stringProperty: String

    //MARK: Convertible
    fileprivate static func from(_ value: Any) throws -> ConvertibleObject {
        guard let string = value as? String else {
            throw MapperError.convertible(value: value, expectedType: String.self)
        }

        return ConvertibleObject(stringProperty: string)
    }
}

class Sequence_ConvertibleSpec: QuickSpec {
    override func spec() {
        describe("Sequence<Convertible>.from") {
            it("should correctly map an array of convertible objects") {
                let sequence: [Any] = [""]
                let models = try! [ConvertibleObject].from(sequence)

                expect(models.count) == sequence.count
            }
        }

        describe("Sequence<Sequence<Convertible>>.from") {
            it("should correctly map a two dimensional array of convertible objects") {
                let sequence: [[Any]] = [[""]]
                let models = try! [[ConvertibleObject]].from(sequence)

                expect(models.count) == sequence.count
            }
        }
    }
}
