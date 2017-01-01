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
            it("should map correctly") {
                let field = Model.Key.mappableProperty
                let expectedValue = [SubModel.Key.stringProperty.stringValue : ""]
                let dict: NSDictionary = [field.stringValue : expectedValue]
                let mapper = KeyedMapper(JSON: dict, type: Model.self)
                let model: SubModel = try! mapper.from(field)

                expect(model).toNot(beNil())
            }
        }

        describe("from<T: Mappable> -> [T]") {
            it("should map correctly") {
                let field = ModelWithArrayProperty.Key.arrayMappableProperty
                let expectedValue = [[SubModel.Key.stringProperty.stringValue : ""]]
                let dict: NSDictionary = [field.stringValue : expectedValue]
                let mapper = KeyedMapper(JSON: dict, type: ModelWithArrayProperty.self)
                let models: [SubModel] = try! mapper.from(field)

                expect(models).toNot(beNil())
                expect(models.count) == expectedValue.count
            }
        }

        describe("from<T: Mappable> -> [[T]]") {
            it("should map correctly") {
                let field = ModelWithTwoDArrayProperty.Key.twoDArrayMappableProperty
                let expectedValue = [[[SubModel.Key.stringProperty.rawValue : ""]]]
                let dict: NSDictionary = [field.stringValue : expectedValue]
                let mapper = KeyedMapper(JSON: dict, type: ModelWithTwoDArrayProperty.self)
                let models: [[SubModel]] = try! mapper.from(field)

                expect(models).toNot(beNil())
                expect(models.count) == expectedValue.count
            }
        }

        describe("optionalFrom<T: Mappable> -> T?") {
            it("should map correctly") {
                let field = Model.Key.mappableProperty
                let expectedValue = [SubModel.Key.stringProperty.stringValue : ""]
                let dict: NSDictionary = [field.rawValue : expectedValue]
                let mapper = KeyedMapper(JSON: dict, type: Model.self)
                let model: SubModel? = mapper.optionalFrom(field)

                expect(model).toNot(beNil())
            }
        }

        describe("optionalFrom<T: Mappable> -> [T]?") {
            it("should map correctly") {
                let field = ModelWithArrayProperty.Key.arrayMappableProperty
                let expectedValue = [[SubModel.Key.stringProperty.stringValue : ""]]
                let dict: NSDictionary = [field.stringValue : expectedValue]
                let mapper = KeyedMapper(JSON: dict, type: ModelWithArrayProperty.self)
                let models: [SubModel]? = mapper.optionalFrom(field)

                expect(models).toNot(beNil())
                expect(models?.count) == expectedValue.count
            }
        }

        describe("optionalFrom<T: Mappable> -> [[T]]?") {
            it("should map correctly") {
                let field = ModelWithTwoDArrayProperty.Key.twoDArrayMappableProperty
                let expectedValue = [[[SubModel.Key.stringProperty.stringValue : ""]]]
                let dict: NSDictionary = [field.stringValue : expectedValue]
                let mapper = KeyedMapper(JSON: dict, type: ModelWithTwoDArrayProperty.self)
                let models: [[SubModel]]? = mapper.optionalFrom(field)

                expect(models).toNot(beNil())
                expect(models?.count) == expectedValue.count
            }
        }
    }
}
