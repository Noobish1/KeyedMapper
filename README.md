[![Build Status](https://travis-ci.org/Noobish1/KeyedMapper.svg?branch=master)](https://travis-ci.org/Noobish1/KeyedMapper) [![codebeat badge](https://codebeat.co/badges/bb395496-29ad-4ab6-8c2f-db58b7dd28a4)](https://codebeat.co/projects/github-com-noobish1-keyedmapper) [![codecov](https://codecov.io/gh/Noobish1/KeyedMapper/branch/master/graph/badge.svg)](https://codecov.io/gh/Noobish1/KeyedMapper) [![CocoaPods](https://img.shields.io/cocoapods/v/KeyedMapper.svg?maxAge=2592000)]()

# KeyedMapper

`KeyedMapper` was inspired heavily by Lyft's [Mapper](https://github.com/lyft/mapper). I wanted something like Mapper but with enums for keys and support for things like `NilConvertible` and `ReverseMappable` so I made `KeyedMapper`. 

# Requirements
 
- Xcode 8+
- Swift 3+
- iOS 8+

# Usage

<details>
<summary>Convertible</summary>
```swift
extension NSTimeZone: Convertible {
    public static func fromMap(_ value: Any) throws -> NSTimeZone {
        guard let name = value as? String else {
            throw MapperError.convertible(value: value, expectedType: String.self)
        }
        
        guard let timeZone = self.init(name: name) else {
            throw MapperError.custom(field: nil, message: "Unsupported timezone \(name)")
        }
        
        return timeZone
    }
}
```
</details>

<details>
<summary>NilConvertible</summary>
```swift
enum NilConvertibleEnum {
    case something
    case nothing
}

extension NilConvertibleEnum: NilConvertible {
    static func fromMap(_ value: Any?) throws -> NilConvertibleEnum {
        if let _ = value {
            return .something
        } else {
            return .nothing
        }
    }
}
```
</details>

<details>
<summary>DefaultConvertible</summary>
```swift
enum DefaultConvertibleEnum: Int, DefaultConvertible {
    case firstCase = 0
}
```
</details>
 
<details>
<summary>Mappable</summary>
```swift
struct SubObject {
    let property: String
}

extension SubObject: Mappable {
    enum Key: String, JSONKey {
        case property
    }

    init(map: KeyedMapper<SubObject>) throws {
        self.property = try map.from(.property)
    }
}

extension SubObject: ReverseMappable {
    func toKeyedJSON() -> [SubObject.Key : Any?] {
        return [.property : property]
    }
}

struct Object {
    let property: String
    let optionalProperty: String?
    let convertibleProperty: NSTimeZone
    let optionalConvertibleProperty: NSTimeZone?
    let nilConvertibleProperty: NilConvertibleEnum
    let arrayProperty: [String]
    let optionalArrayProperty: [String]?
    let mappableProperty: SubObject
    let optionalMappableProperty: SubObject?
    let defaultConvertibleProperty: DefaultConvertibleEnum
    let optionalDefaultConvertibleProperty: DefaultConvertibleEnum?
    let twoDArrayProperty: [[String]]
    let optionalTwoDArrayProperty: [[String]]?
}

extension Object: Mappable {
    enum Key: String, JSONKey {
        case property
        case optionalProperty
        case convertibleProperty
        case optionalConvertibleProperty
        case nilConvertibleProperty
        case arrayProperty
        case optionalArrayProperty
        case mappableProperty
        case optionalMappableProperty
        case defaultConvertibleProperty
        case optionalDefaultConvertibleProperty
        case twoDArrayProperty
        case optionalTwoDArrayProperty
    }
    
    init(map: KeyedMapper<Object>) throws {
        self.property = try map.from(.property)
        self.optionalProperty = map.optionalFrom(.optionalProperty)
        self.convertibleProperty = try map.from(.convertibleProperty)
        self.optionalConvertibleProperty = map.optionalFrom(.optionalConvertibleProperty)
        self.nilConvertibleProperty = try map.from(.nilConvertibleProperty)
        self.arrayProperty = try map.from(.arrayProperty)
        self.optionalArrayProperty = map.optionalFrom(.optionalArrayProperty)
        self.mappableProperty = try map.from(.mappableProperty)
        self.optionalMappableProperty = map.optionalFrom(.optionalMappableProperty)
        self.defaultConvertibleProperty = try map.from(.defaultConvertibleProperty)
        self.optionalDefaultConvertibleProperty = map.optionalFrom(.optionalDefaultConvertibleProperty)
        self.twoDArrayProperty = try map.from(.twoDArrayProperty)
        self.optionalTwoDArrayProperty = map.optionalFrom(.optionalTwoDArrayProperty)
    }
}

let JSON: NSDictionary = ["property" : "propertyValue",
                         "convertibleProperty" : NSTimeZone(forSecondsFromGMT: 0).abbreviation as Any,
                         "arrayProperty" : ["arrayPropertyValue1", "arrayPropertyValue2"],
                         "mappableProperty" : ["property" : "propertyValue"],
                         "defaultConvertibleProperty" : DefaultConvertibleEnum.firstCase.rawValue,
                         "twoDArrayProperty" : [["twoDArrayPropertyValue1"], ["twoDArrayPropertyValue2"]]]

let object = try Object.from(dictionary: JSON)
```
</details>

<details>
<summary>ReverseMappable</summary>

```swift
extension Object: ReverseMappable {
    func toKeyedJSON() -> [Object.Key : Any?] {
        return [.property : property,
                .optionalProperty : optionalProperty,
                .convertibleProperty : convertibleProperty,
                .optionalConvertibleProperty : optionalConvertibleProperty,
                .nilConvertibleProperty : nilConvertibleProperty,
                .arrayProperty : arrayProperty,
                .optionalArrayProperty : optionalArrayProperty,
                .mappableProperty : mappableProperty.toJSON(),
                .optionalMappableProperty : optionalMappableProperty?.toJSON(),
                .defaultConvertibleProperty : defaultConvertibleProperty,
                .optionalDefaultConvertibleProperty : optionalDefaultConvertibleProperty,
                .twoDArrayProperty : twoDArrayProperty,
                .optionalTwoDArrayProperty : optionalTwoDArrayProperty
        ]
    }
}

let outJSON = object.toJSON()
```
</details>
