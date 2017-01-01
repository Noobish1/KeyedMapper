import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct ConvertibleObject: Convertible, Hashable, Equatable {
    fileprivate let stringProperty: String

    //MARK: Convertible
    fileprivate static func from(_ value: Any) throws -> ConvertibleObject {
        guard let string = value as? String else {
            throw MapperError.convertible(value: value, expectedType: String.self)
        }

        return ConvertibleObject(stringProperty: string)
    }

    //MARK: Hashable
    fileprivate var hashValue: Int {
        return stringProperty.hashValue
    }

    //MARK: Equatable
    fileprivate static func == (lhs: ConvertibleObject, rhs: ConvertibleObject) -> Bool {
        return lhs.stringProperty == rhs.stringProperty
    }
}

fileprivate struct Model: Mappable {
    fileprivate enum Key: String, JSONKey {
        case convertibleProperty
    }

    fileprivate let convertibleProperty: ConvertibleObject

    fileprivate init(map: KeyedMapper<Model>) throws {
        try self.convertibleProperty = map.from(.convertibleProperty)
    }
}

fileprivate struct ModelWithArrayProperty: Mappable {
    fileprivate enum Key: String, JSONKey {
        case convertibleArrayProperty
    }

    fileprivate let convertibleArrayProperty: [ConvertibleObject]

    fileprivate init(map: KeyedMapper<ModelWithArrayProperty>) throws {
        try self.convertibleArrayProperty = map.from(.convertibleArrayProperty)
    }
}

fileprivate struct ModelWithDictionaryProperty: Mappable {
    fileprivate enum Key: String, JSONKey {
        case convertibleDictionaryProperty
    }

    fileprivate let convertibleDictionaryProperty: [ConvertibleObject : [ConvertibleObject]]

    fileprivate init(map: KeyedMapper<ModelWithDictionaryProperty>) throws {
        try self.convertibleDictionaryProperty = map.from(.convertibleDictionaryProperty)
    }
}

fileprivate struct ModelWithTwoDArrayProperty: Mappable {
    fileprivate enum Key: String, JSONKey {
        case convertibleTwoDArrayProperty
    }

    fileprivate let convertibleTwoDArrayProperty: [[ConvertibleObject]]

    fileprivate init(map: KeyedMapper<ModelWithTwoDArrayProperty>) throws {
        try self.convertibleTwoDArrayProperty = map.from(.convertibleTwoDArrayProperty)
    }
}

class KeyedMapper_ConvertibleSpec: QuickSpec {
    override func spec() {
        describe("from<T: Convertible> -> T") {
            it("should correctly map") {
                let field = Model.Key.convertibleProperty
                let dict: NSDictionary = [field.stringValue : ""]
                let mapper = try! KeyedMapper(JSON: dict, type: Model.self)
                let convertibleThing: ConvertibleObject = try! mapper.from(field)

                expect(convertibleThing).toNot(beNil())
            }
        }

        describe("from<T: Convertible> -> [T]") {
            it("should map correctly") {
                let field = ModelWithArrayProperty.Key.convertibleArrayProperty
                let expectedValue = [""]
                let dict: NSDictionary = [field.stringValue : expectedValue]
                let mapper = try! KeyedMapper(JSON: dict, type: ModelWithArrayProperty.self)
                let convertibleArray: [ConvertibleObject] = try! mapper.from(field)

                expect(convertibleArray.count) == expectedValue.count
            }
        }

        describe("from<T: Convertible> -> [[T]]") {
            it("should map correctly") {
                let field = ModelWithTwoDArrayProperty.Key.convertibleTwoDArrayProperty
                let expectedValue = [""]
                let dict: NSDictionary = [field.stringValue : [expectedValue]]
                let mapper = try! KeyedMapper(JSON: dict, type: ModelWithTwoDArrayProperty.self)
                let convertibleArray: [[ConvertibleObject]] = try! mapper.from(field)

                expect(convertibleArray.count) == expectedValue.count
            }
        }

        describe("from<T: Convertible> -> [U : [T]]") {
            let field = ModelWithDictionaryProperty.Key.convertibleDictionaryProperty

            context("when one of the dictionary values cannot be cast to an [Any]") {
                it("should return a typeMismatch error") {
                    let value: NSDictionary = ["" : [:]]
                    let dict: NSDictionary = [field.stringValue : value]
                    let mapper = try! KeyedMapper(JSON: dict, type: ModelWithDictionaryProperty.self)

                    do {
                        let _: [ConvertibleObject : [ConvertibleObject]] = try mapper.from(field)
                    } catch let error as MapperError {
                        expect(error) == MapperError.typeMismatch(field: field.stringValue, forType: ModelWithDictionaryProperty.self, value: value, expectedType: [Any].self)
                    } catch {
                        XCTFail("Error thrown from from<T: Convertible> -> [U : [T]] was not a MapperError")
                    }
                }
            }

            context("when all of the dictionary values can be cast to NSArrays") {
                it("should return the correctly converted objects") {
                    let value: NSDictionary = ["" : [""]]
                    let dict: NSDictionary = [field.stringValue : value]
                    let mapper = try! KeyedMapper(JSON: dict, type: ModelWithDictionaryProperty.self)
                    let convertibleDictionary: [ConvertibleObject : [ConvertibleObject]] = try! mapper.from(field)

                    expect(convertibleDictionary.values.count) == value.count
                }
            }
        }

        describe("optionalFrom<T: Convertible> -> T?") {
            it("should correctly map") {
                let field = Model.Key.convertibleProperty
                let dict: NSDictionary = [field.stringValue : ""]
                let mapper = try! KeyedMapper(JSON: dict, type: Model.self)
                let convertibleThing: ConvertibleObject? = mapper.optionalFrom(field)

                expect(convertibleThing).toNot(beNil())
            }
        }

        describe("optionalFrom<T: Convertible> -> [T]?") {
            it("should map correctly") {
                let field = ModelWithArrayProperty.Key.convertibleArrayProperty
                let expectedValue = [""]
                let dict: NSDictionary = [field.stringValue : expectedValue]
                let mapper = try! KeyedMapper(JSON: dict, type: ModelWithArrayProperty.self)
                let convertibleArray: [ConvertibleObject]? = mapper.optionalFrom(field)

                expect(convertibleArray).toNot(beNil())
                expect(convertibleArray?.count) == expectedValue.count
            }
        }

        describe("optionalFrom<T: Convertible> -> [[T]]?") {
            it("should map correctly") {
                let field = ModelWithTwoDArrayProperty.Key.convertibleTwoDArrayProperty
                let expectedValue = [""]
                let dict: NSDictionary = [field.stringValue : [expectedValue]]
                let mapper = try! KeyedMapper(JSON: dict, type: ModelWithTwoDArrayProperty.self)
                let convertibleArray: [[ConvertibleObject]]? = mapper.optionalFrom(field)

                expect(convertibleArray?.count) == expectedValue.count
            }
        }

        describe("optionalFrom<T: Convertible> -> [U : [T]]?") {
            it("should return the correctly converted objects") {
                let field = ModelWithDictionaryProperty.Key.convertibleDictionaryProperty
                let value: NSDictionary = ["" : [""]]
                let dict: NSDictionary = [field.stringValue : value]
                let mapper = try! KeyedMapper(JSON: dict, type: ModelWithDictionaryProperty.self)
                let convertibleDictionary: [ConvertibleObject : [ConvertibleObject]]? = mapper.optionalFrom(field)

                expect(convertibleDictionary?.values.count) == value.count
            }
        }
    }
}
