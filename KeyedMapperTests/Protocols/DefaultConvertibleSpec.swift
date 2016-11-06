import Quick
import Nimble
@testable import KeyedMapper

private enum DefaultConvertibleEnum: Int, DefaultConvertible {
    case FirstCase = 0
}

class DefaultConvertibleSpec: QuickSpec {
    override func spec() {
        describe("DefaultConvertible") {
            describe("fromMap") {
                context("when the object is not RawRepresentable") {
                    context("when the given value cannot be cast to the ConvertedType") {
                        it("should throw a ConvertibleError") {
                            let value = "" as AnyObject
                            let type = Int.self

                            do {
                                _ = try type.fromMap(value)
                            } catch let error as MapperError {
                                expect(error) == MapperError.convertible(value: value, expectedType: type)
                            } catch {
                                XCTFail("Error thrown from DefaultConvertible.fromMap was not a MapperError")
                            }
                        }
                    }

                    context("when the given value can be cast to the ConvertedType") {
                        it("should return the converted object") {
                            let expectedValue = 1
                            let actualValue = try! Int.fromMap(expectedValue as AnyObject)

                            expect(actualValue) == expectedValue
                        }
                    }
                }

                context("when the object is RawRepresentable") {
                    context("when the given value cannot be cast to the type of the rawValue") {
                        it("should throw a ConvertibleError") {
                            let value = "" as AnyObject
                            let type = DefaultConvertibleEnum.self

                            do {
                                _ = try type.fromMap(value)
                            } catch let error as MapperError {
                                expect(error) == MapperError.convertible(value: value, expectedType: type.RawValue.self)
                            } catch {
                                XCTFail("Error thrown from DefaultConvertible.fromMap was not a MapperError")
                            }
                        }
                    }
                }

                context("when the given value can be cast to the type of the rawValue") {
                    context("when the given value is not a valid rawValue of the object") {
                        it("should throw a customError with a relevant message") {
                            let value = 1
                            let type = DefaultConvertibleEnum.self

                            do {
                                _ = try type.fromMap(value)
                            } catch let error as MapperError {
                                expect(error) == MapperError.invalidRawValue(rawValueType: type(of: value), rawValue: value, expectedType: type)
                            } catch {
                                XCTFail("Error thrown from DefaultConvertible.fromMap was not a MapperError")
                            }
                        }
                    }

                    context("when the given value is a valid rawValue of the object") {
                        it("should return the converted object") {
                            let expectedValue = DefaultConvertibleEnum.FirstCase.rawValue
                            let type = DefaultConvertibleEnum.self
                            let actualValue = try! type.fromMap(expectedValue)

                            expect(actualValue.rawValue) == expectedValue
                        }
                    }
                }
            }
        }
    }
}
