import Quick
import Nimble
@testable import KeyedMapper

class NSDictionarySpec: QuickSpec {
    override func spec() {
        describe("NSDictionary") { 
            describe("safeValueForKeyPath") {
                context("when given an empty string") {
                    it("should return the entire dictionary") {
                        let dict: NSDictionary = ["key" : "value"]
                        let value = dict.safeValueForKeyPath("") as? NSDictionary
                        
                        expect(value) == dict
                    }
                }
                
                context("when given an single key") {
                    context("when the value exists for the given key") {
                        it("should return the value for the given key") {
                            let key = "key"
                            let expectedValue = "value"
                            let dict: NSDictionary = [key : expectedValue]
                            let value = dict.safeValueForKeyPath(key) as? String
                            
                            expect(value) == expectedValue
                        }
                    }
                    
                    context("when the value does not exist for the given key") {
                        it("should return nil") {
                            let key = "key"
                            let dict: NSDictionary = [:]
                            let value = dict.safeValueForKeyPath(key) as? String
                            
                            expect(value).to(beNil())
                        }
                    }
                }
                
                context("when given a two part keypath") {
                    context("when the value exists for the given keypath") {
                        it("should return the value for the given keypath") {
                            let firstKey = "firstKey"
                            let secondKey = "secondKey"
                            let keyPath = "\(firstKey).\(secondKey)"
                            let expectedValue = "value"
                            let dict: NSDictionary = [firstKey : [secondKey : expectedValue]]
                            let value = dict.safeValueForKeyPath(keyPath) as? String
                            
                            expect(value) == expectedValue
                        }
                    }
                    
                    context("when the value does not exist for the given keypath") {
                        it("should return nil") {
                            let firstKey = "firstKey"
                            let secondKey = "secondKey"
                            let keyPath = "\(firstKey).\(secondKey)"
                            let dict: NSDictionary = [firstKey : [:]]
                            let value = dict.safeValueForKeyPath(keyPath) as? String
                            
                            expect(value).to(beNil())
                        }
                    }
                }
            }
        }
    }
}
