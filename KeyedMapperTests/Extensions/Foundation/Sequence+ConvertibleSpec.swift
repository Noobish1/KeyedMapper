import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct ConvertibleObject: Convertible {
    fileprivate let stringProperty: String

    //MARK: Convertible
    fileprivate static func fromMap(_ value: Any) throws -> ConvertibleObject {
        guard let string = value as? String else {
            throw MapperError.convertible(value: value, expectedType: String.self)
        }

        return ConvertibleObject(stringProperty: string)
    }
}

class Sequence_ConvertibleSpec: QuickSpec {
    override func spec() {
        describe("Sequence<Convertible>.fromMap") {
            it("should correctly map an array of mappable objects") {
                let sequence: [Any] = [""]
                let models = try! [ConvertibleObject].fromMap(sequence)

                expect(models.count) == sequence.count
            }
        }
    }
}
