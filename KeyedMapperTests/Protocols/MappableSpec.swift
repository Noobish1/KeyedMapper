import Quick
import Nimble
@testable import KeyedMapper

fileprivate struct ModelWithStringProperty: Mappable {
    fileprivate let stringProperty: String
    
    fileprivate enum Key: String, JSONKey {
        case stringProperty = "stringProperty"
    }
    
    fileprivate init(map: KeyedMapper<ModelWithStringProperty>) throws {
        try self.stringProperty = map.from(.stringProperty)
    }
}

extension ModelWithStringProperty: Equatable {
    fileprivate static func == (lhs: ModelWithStringProperty, rhs: ModelWithStringProperty) -> Bool {
        return lhs.stringProperty == rhs.stringProperty
    }
}

class MappableSpec: QuickSpec {
    override func spec() {
        describe("Mappable") {
            describe("from NSArray") {
                context("when the passed in array is not an array of NSDictionaries") {
                    it("should throw a MapperError.rootTypeMismatchError") {
                        let JSON: NSArray = [1]
                        
                        do {
                            _ = try ModelWithStringProperty.from(JSON: JSON)
                        } catch let error as MapperError<ModelWithStringProperty> {
                            expect(error) == MapperError.rootTypeMismatchError(forType: ModelWithStringProperty.self, value: JSON, expectedType: [NSDictionary].self)
                        } catch {
                            XCTFail("Error thrown from from(JSON: NSArray) was not a MapperError")
                        }
                    }
                }
                
                context("when the passed in array is an array of NSDictionaries") {
                    it("should map the model correctly") {
                        let model = try! ModelWithStringProperty.from(JSON: ["stringProperty": ""])
                        let models = try! ModelWithStringProperty.from(JSON: [["stringProperty": ""]])
                        
                        expect(models) == [model]
                    }
                }
            }
        }
    }
}
