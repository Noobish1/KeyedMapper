import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct ConvertibleObject: Convertible {
    fileprivate let stringProperty: String
    
    fileprivate static func fromMap(_ value: Any?) throws -> ConvertibleObject {
        return ConvertibleObject(stringProperty: value as! String)
    }
}

fileprivate struct Model: Mappable {
    fileprivate enum Key: String, JSONKey {
        case convertibleProperty
        case convertibleArrayProperty
    }
    
    fileprivate let convertibleProperty: ConvertibleObject
    fileprivate let convertibleArrayProperty: [ConvertibleObject]
    
    fileprivate init(map: KeyedMapper<Model>) throws {
        try self.convertibleProperty = map.from(.convertibleProperty)
        try self.convertibleArrayProperty = map.from(.convertibleArrayProperty)
    }
}

class KeyedMapper_ConvertibleSpec: QuickSpec {
    override func spec() {
        describe("from<T: Convertible> -> T") {
            it("should correctly map") {
                let dict: NSDictionary = ["convertibleProperty" : ""]
                let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                let convertibleThing: ConvertibleObject = try! mapper.from(.convertibleProperty)
                
                expect(convertibleThing).toNot(beNil())
            }
        }
        
        describe("from<T: Convertible> -> [T]") {
            context("when the value cannot be casted to an array of Any") {
                it("should throw a typeMismatchError") {
                    let expectedValue: NSDictionary = [:]
                    let dict: NSDictionary = ["convertibleArrayProperty" : [:]]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    
                    do {
                        let _: [ConvertibleObject] = try mapper.from(.convertibleArrayProperty)
                    } catch let error as MapperError<Model> {
                        expect(error) == MapperError.typeMismatchError(field: .convertibleArrayProperty, forType: Model.self, value: expectedValue, expectedType: [Any].self)
                    } catch {
                        XCTFail("Error thrown from from<T: Convertible> -> [T] was not a MapperError")
                    }
                }
            }
            
            context("when the value can be casted to an array of Any") {
                it("should map correctly") {
                    let expectedValue = [""]
                    let dict: NSDictionary = ["convertibleArrayProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let convertibleArray: [ConvertibleObject] = try! mapper.from(.convertibleArrayProperty)
                    
                    expect(convertibleArray.count) == expectedValue.count
                }
            }
        }
    }
}
