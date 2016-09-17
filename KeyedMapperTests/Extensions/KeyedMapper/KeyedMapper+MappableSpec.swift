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
        case arrayMappableProperty
    }
    
    fileprivate let mappableProperty: SubModel
    fileprivate let arrayMappableProperty: [SubModel]
    
    fileprivate init(map: KeyedMapper<Model>) throws {
        try self.mappableProperty = map.from(.mappableProperty)
        try self.arrayMappableProperty = map.from(.arrayMappableProperty)
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
                    } catch let error as MapperError {
                        expect(error) == MapperError.typeMismatchError(field: Model.Key.mappableProperty.stringValue, forType: Model.self, value: expectedValue, expectedType: NSDictionary.self)
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
        
        describe("from<T: Mappable> -> [T]") {
            context("when the value in the JSON is not an array of NSDictionaries") {
                it("should throw a typeMismatchError") {
                    let expectedValue = 2
                    let dict: NSDictionary = ["arrayMappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let field = Model.Key.arrayMappableProperty
                    
                    do {
                        let _: [SubModel] = try mapper.from(field)
                    } catch let error as MapperError {
                        expect(error) == MapperError.typeMismatchError(field: field.stringValue, forType: Model.self, value: expectedValue, expectedType: [NSDictionary].self)
                    } catch {
                        XCTFail("Error thrown from KeyedMapper<T: Mappable>.from was not a MapperError")
                    }
                }
            }
            
            context("when the value in the JSON is an array of NSDictionaries") {
                it("should map correctly") {
                    let expectedValue = [["stringProperty" : ""]]
                    let dict: NSDictionary = ["arrayMappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let models: [SubModel] = try! mapper.from(.arrayMappableProperty)
                    
                    expect(models).toNot(beNil())
                    expect(models.count) == expectedValue.count
                }
            }
        }
        
        describe("optionalFrom<T: Mappable> -> T?") {
            context("when the value in the JSON is not an NSDictionary") {
                it("should throw a typeMismatchError") {
                    let expectedValue = 2
                    let dict: NSDictionary = ["mappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let model: SubModel? = mapper.optionalFrom(.mappableProperty)
                    
                    expect(model).to(beNil())
                }
            }
            
            context("when the value in the JSON is an NSDictionary") {
                it("should map correctly") {
                    let expectedValue = ["stringProperty" : ""]
                    let dict: NSDictionary = ["mappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let model: SubModel? = mapper.optionalFrom(.mappableProperty)
                    
                    expect(model).toNot(beNil())
                }
            }
        }
        
        describe("from<T: Mappable> -> [T]") {
            context("when the value in the JSON is not an array of NSDictionaries") {
                it("should throw a typeMismatchError") {
                    let expectedValue = 2
                    let dict: NSDictionary = ["arrayMappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let models: [SubModel]? = mapper.optionalFrom(.arrayMappableProperty)
                    
                    expect(models).to(beNil())
                }
            }
            
            context("when the value in the JSON is an array of NSDictionaries") {
                it("should map correctly") {
                    let expectedValue = [["stringProperty" : ""]]
                    let dict: NSDictionary = ["arrayMappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let models: [SubModel]? = mapper.optionalFrom(.arrayMappableProperty)
                    
                    expect(models).toNot(beNil())
                    expect(models?.count) == expectedValue.count
                }
            }
        }
    }
}
