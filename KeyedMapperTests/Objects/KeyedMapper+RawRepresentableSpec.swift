import Quick
import Nimble
@testable import KeyedMapper

fileprivate enum ModelEnum: String {
    case SomeCase
}

fileprivate struct Model: Mappable {
    fileprivate enum Key: String, JSONKey {
        case enumProperty
    }
    
    fileprivate let enumProperty: ModelEnum
    
    fileprivate init(map: KeyedMapper<Model>) throws {
        try self.enumProperty = map.from(.enumProperty)
    }
}

class KeyedMapper_RawRepresentableSpec: QuickSpec {
    override func spec() {
        describe("from<T: RawRepresentable>") {
            context("when the value for the given field in the JSON cannot be converted to T's RawValue") {
                it("should throw a typeMismatchError") {
                    let expectedValue = 2
                    let dict: NSDictionary = ["enumProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    
                    do {
                        let _: ModelEnum = try mapper.from(.enumProperty)
                    } catch let error as MapperError<Model> {
                        expect(error) == MapperError.typeMismatchError(field: .enumProperty, forType: Model.self, value: expectedValue, expectedType: ModelEnum.RawValue.self)
                    } catch {
                        XCTFail("Error thrown from JSONFromField was not a MapperError")
                    }
                }
            }
            
            context("when the value for the given field in the JSON is not one of the valid rawValue's") {
                it("should throw a invalidRawValueError") {
                    let expectedValue = "someOtherCase"
                    let dict: NSDictionary = ["enumProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    
                    do {
                        let _: ModelEnum = try mapper.from(.enumProperty)
                    } catch let error as MapperError<Model> {
                        expect(error) == MapperError.invalidRawValueError(field: .enumProperty, forType: Model.self, value: expectedValue, expectedType: ModelEnum.self)
                    } catch {
                        XCTFail("Error thrown from JSONFromField was not a MapperError")
                    }
                }
            }
        }
    }
}
