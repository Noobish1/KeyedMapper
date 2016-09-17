import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct SubModel: Mappable {
    fileprivate enum Key: String, JSONKey {
        case stringProperty
    }

    fileprivate let stringProperty: String
    
    fileprivate init(map: KeyedMapper<SubModel>) throws {
        try self.stringProperty = map.from(.stringProperty)
    }
}

fileprivate struct Model: Mappable {
    fileprivate enum Key: String, JSONKey {
        case mappableProperty
    }
    
    fileprivate let mappableProperty: SubModel
    
    fileprivate init(map: KeyedMapper<Model>) throws {
        try self.mappableProperty = map.from(.mappableProperty)
    }
}

class KeyedMapper_MappableSpec: QuickSpec {
    override func spec() {
        describe("from<T: Mappable> -> T") {
            context("when the value in the JSON is not an NSDictionary") {
                it("should throw a typeMismatchError") {
                    let expectedValue = 2
                    let dict: NSDictionary = ["mappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    
                    do {
                        let _: SubModel = try mapper.from(.mappableProperty)
                    } catch let error as MapperError<Model> {
                        expect(error) == MapperError.typeMismatchError(field: .mappableProperty, forType: Model.self, value: expectedValue, expectedType: NSDictionary.self)
                    } catch {
                        XCTFail("Error thrown from KeyedMapper<T: Mappable>.from was not a MapperError")
                    }
                }
            }
            
            context("when the value in the JSON is an NSDictionary") {
                it("should map correctly") {
                    let expectedValue = ["stringProperty" : ""]
                    let dict: NSDictionary = ["mappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let model: SubModel = try! mapper.from(.mappableProperty)
                    
                    expect(model).toNot(beNil())
                }
            }
        }
    }
}
