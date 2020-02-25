//
//  PerformanceTests.swift
//  PerformanceTests
//
//  Created by Blair McArthur on 1/11/16.
//  Copyright © 2016 Noobish1. All rights reserved.
//

import XCTest
import TestModels
import KeyedMapper

fileprivate let numberOfTests = 40000

class KeyedMapper_Tests: XCTestCase {
    func testDeserialization() {
        self.measure {
            let d: NSDictionary = try! JSONSerialization.jsonObject(with: self.data, options: []) as! NSDictionary
            XCTAssert(d.count > 0)
        }
    }

    func testPerformance() {
        let dict = try! JSONSerialization.jsonObject(with: self.data, options: []) as! NSDictionary

        self.measure {
            let programList = try! ProgramList.from(dict)
            XCTAssert(programList.programs.count > 1000)
        }
    }

    private lazy var data:Data = {
        let path = Bundle(for: type(of: self)).url(forResource: "Large", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        return data
    }()

    private lazy var keyedDict: NSDictionary = {
        return ["user" : ["name" : "username"], "timestamp" : "123"]
    }()

    func testSafeValueWithExistingCode() {
        let dict = keyedDict

        self.measure {
            for _ in 0...numberOfTests {
                let wholeDict = self.existingSafeValue(forField: "", in: dict)
                let username = self.existingSafeValue(forField: "user.name", in: dict)
                let timestamp = self.existingSafeValue(forField: "timestamp", in: dict)

                XCTAssertEqual(wholeDict as? NSDictionary, dict)
                XCTAssertEqual(username as? String, "username")
                XCTAssertEqual(timestamp as? String, "123")
            }
        }
    }

    func testSafeValueWithEmptyCheck() {
        let dict = keyedDict

        self.measure {
            for _ in 0...numberOfTests {
                let wholeDict = self.safeValueWithEmptyCheck(forField: "", in: dict)
                let username = self.safeValueWithEmptyCheck(forField: "user.name", in: dict)
                let timestamp = self.safeValueWithEmptyCheck(forField: "timestamp", in: dict)

                XCTAssertEqual(wholeDict as? NSDictionary, dict)
                XCTAssertEqual(username as? String, "username")
                XCTAssertEqual(timestamp as? String, "123")
            }
        }
    }

    func testSafeValueWithEmptyCheckAndDotCheck() {
        let dict = keyedDict

        self.measure {
            for _ in 0...numberOfTests {
                let wholeDict = self.safeValueWithEmptyCheckAndDotCheck(forField: "", in: dict)
                let username = self.safeValueWithEmptyCheckAndDotCheck(forField: "user.name", in: dict)
                let timestamp = self.safeValueWithEmptyCheckAndDotCheck(forField: "timestamp", in: dict)

                XCTAssertEqual(wholeDict as? NSDictionary, dict)
                XCTAssertEqual(username as? String, "username")
                XCTAssertEqual(timestamp as? String, "123")
            }
        }
    }

    private func existingSafeValue(forField field: String, in dictionary: NSDictionary) -> Any? {
        var object: Any? = dictionary
        var keys = field.split(separator: ".").map(String.init)

        while !keys.isEmpty, let currentObject = object {
            let key = keys.removeFirst()
            object = (currentObject as? NSDictionary)?[key]
        }

        return object
    }

    private func safeValueWithEmptyCheck(forField field: String, in dictionary: NSDictionary) -> Any? {
        guard !field.isEmpty else {
            return dictionary
        }

        var object: Any? = dictionary
        var keys = field.split(separator: ".").map(String.init)

        while !keys.isEmpty, let currentObject = object {
            let key = keys.removeFirst()
            object = (currentObject as? NSDictionary)?[key]
        }

        return object
    }

    private func safeValueWithEmptyCheckAndDotCheck(forField field: String, in dictionary: NSDictionary) -> Any? {
        guard !field.isEmpty else {
            return dictionary
        }

        guard field.contains(".") else {
            return dictionary[field]
        }

        var object: Any? = dictionary
        var keys = field.split(separator: ".").map(String.init)

        while !keys.isEmpty, let currentObject = object {
            let key = keys.removeFirst()
            object = (currentObject as? NSDictionary)?[key]
        }

        return object
    }
}
