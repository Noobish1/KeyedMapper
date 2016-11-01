import Quick
import Nimble
@testable import KeyedMapper

fileprivate enum ModelEnum: String {
    case someCase
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
                    let field = Model.Key.enumProperty
                    
                    do {
                        let _: ModelEnum = try mapper.from(field)
                    } catch let error as MapperError {
                        expect(error) == MapperError.typeMismatchError(field: field.stringValue, forType: Model.self, value: expectedValue, expectedType: ModelEnum.RawValue.self)
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
                    let field = Model.Key.enumProperty
                    
                    do {
                        let _: ModelEnum = try mapper.from(field)
                    } catch let error as MapperError {
                        expect(error) == MapperError.invalidRawValueError(field: field.stringValue, forType: Model.self, value: expectedValue, expectedType: ModelEnum.self)
                    } catch {
                        XCTFail("Error thrown from JSONFromField was not a MapperError")
                    }
                }
            }
            
            context("when the value for the given field in the JSON is one of the valid rawValue's") {
                it("should create the RawRepresentable value") {
                    let expectedValue = "someCase"
                    let dict: NSDictionary = ["enumProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    
                    let actualEnum: ModelEnum = try! mapper.from(.enumProperty)
                    
                    expect(actualEnum) == ModelEnum.someCase
                }
            }
        }
        
        describe("optionalFrom<T: RawRepresentable>") {
            context("when the value for the given field in the JSON cannot be converted to T's RawValue") {
                it("should return nil") {
                    let dict: NSDictionary = ["enumProperty" : 2]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let actualEnum: ModelEnum? = mapper.optionalFrom(.enumProperty)
                    
                    expect(actualEnum).to(beNil())
                }
            }
            
            context("when the value for the given field in the JSON is not one of the valid rawValue's") {
                it("should throw a invalidRawValueError") {
                    let dict: NSDictionary = ["enumProperty" : "someOtherCase"]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let actualEnum: ModelEnum? = mapper.optionalFrom(.enumProperty)
                    
                    expect(actualEnum).to(beNil())
                }
            }
            
            context("when the value for the given field in the JSON is one of the valid rawValue's") {
                it("should create the RawRepresentable value") {
                    let expectedValue = "someCase"
                    let dict: NSDictionary = ["enumProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    
                    let actualEnum: ModelEnum? = mapper.optionalFrom(.enumProperty)
                    
                    expect(actualEnum) == ModelEnum.someCase
                }
            }
        }
    }
}
