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

fileprivate struct ModelWithArrayProperty: Mappable {
    fileprivate enum Key: String, JSONKey {
        case arrayMappableProperty
    }

    fileprivate let arrayMappableProperty: [SubModel]

    fileprivate init(map: KeyedMapper<ModelWithArrayProperty>) throws {
        try self.arrayMappableProperty = map.from(.arrayMappableProperty)
    }
}


fileprivate struct ModelWithTwoDArrayProperty: Mappable {
    fileprivate enum Key: String, JSONKey {
        case twoDArrayMappableProperty
    }

    fileprivate let twoDArrayMappableProperty: [[SubModel]]

    fileprivate init(map: KeyedMapper<ModelWithTwoDArrayProperty>) throws {
        try self.twoDArrayMappableProperty = map.from(.twoDArrayMappableProperty)
    }
}

class KeyedMapper_MappableSpec: QuickSpec {
    override func spec() {
        describe("from<T: Mappable> -> T") {
            context("when the value in the JSON is not an Dictionary") {
                it("should throw a typeMismatch error") {
                    let expectedValue = 2
                    let dict: NSDictionary = ["mappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    
                    do {
                        let _: SubModel = try mapper.from(.mappableProperty)
                    } catch let error as MapperError {
                        expect(error) == MapperError.typeMismatch(field: Model.Key.mappableProperty.stringValue, forType: Model.self, value: expectedValue, expectedType: NSDictionary.self)
                    } catch {
                        XCTFail("Error thrown from KeyedMapper<T: Mappable>.from was not a MapperError")
                    }
                }
            }
            
            context("when the value in the JSON is an Dictionary") {
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
            context("when the value in the JSON is not an array of Dictionaries") {
                it("should throw a typeMismatch error") {
                    let expectedValue = 2
                    let dict: NSDictionary = ["arrayMappableProperty" : expectedValue]
                    let mapper = KeyedMapper(JSON: dict, type: ModelWithArrayProperty.self)
                    let field = ModelWithArrayProperty.Key.arrayMappableProperty
                    
                    do {
                        let _: [SubModel] = try mapper.from(field)
                    } catch let error as MapperError {
                        expect(error) == MapperError.typeMismatch(field: field.stringValue, forType: ModelWithArrayProperty.self, value: expectedValue, expectedType: [NSDictionary].self)
                    } catch {
                        XCTFail("Error thrown from KeyedMapper<T: Mappable>.from was not a MapperError")
                    }
                }
            }
            
            context("when the value in the JSON is an array of Dictionaries") {
                it("should map correctly") {
                    let expectedValue = [["stringProperty" : ""]]
                    let dict: NSDictionary = ["arrayMappableProperty" : expectedValue]
                    let mapper = KeyedMapper(JSON: dict, type: ModelWithArrayProperty.self)
                    let models: [SubModel] = try! mapper.from(.arrayMappableProperty)
                    
                    expect(models).toNot(beNil())
                    expect(models.count) == expectedValue.count
                }
            }
        }
        
        describe("optionalFrom<T: Mappable> -> T?") {
            context("when the value in the JSON is not an Dictionary") {
                it("should throw a typeMismatch error") {
                    let expectedValue = 2
                    let dict: NSDictionary = ["mappableProperty" : expectedValue]
                    let mapper = KeyedMapper<Model>(JSON: dict, type: Model.self)
                    let model: SubModel? = mapper.optionalFrom(.mappableProperty)
                    
                    expect(model).to(beNil())
                }
            }
            
            context("when the value in the JSON is an Dictionary") {
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
            context("when the value in the JSON is not an array of Dictionaries") {
                it("should throw a typeMismatch error") {
                    let expectedValue = 2
                    let dict: NSDictionary = ["arrayMappableProperty" : expectedValue]
                    let mapper = KeyedMapper(JSON: dict, type: ModelWithArrayProperty.self)
                    let models: [SubModel]? = mapper.optionalFrom(.arrayMappableProperty)
                    
                    expect(models).to(beNil())
                }
            }
            
            context("when the value in the JSON is an array of Dictionaries") {
                it("should map correctly") {
                    let expectedValue = [["stringProperty" : ""]]
                    let dict: NSDictionary = ["arrayMappableProperty" : expectedValue]
                    let mapper = KeyedMapper(JSON: dict, type: ModelWithArrayProperty.self)
                    let models: [SubModel]? = mapper.optionalFrom(.arrayMappableProperty)
                    
                    expect(models).toNot(beNil())
                    expect(models?.count) == expectedValue.count
                }
            }
        }
    }
}
