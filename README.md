[![Build Status](https://travis-ci.org/Noobish1/KeyedMapper.svg?branch=master)](https://travis-ci.org/Noobish1/KeyedMapper) [![codebeat badge](https://codebeat.co/badges/bb395496-29ad-4ab6-8c2f-db58b7dd28a4)](https://codebeat.co/projects/github-com-noobish1-keyedmapper) [![codecov](https://codecov.io/gh/Noobish1/KeyedMapper/branch/master/graph/badge.svg)](https://codecov.io/gh/Noobish1/KeyedMapper) [![CocoaPods](https://img.shields.io/cocoapods/v/KeyedMapper.svg?maxAge=2592000)]()

# KeyedMapper

Swift KeyedMapper
 
# Usage
 
## Convertible
 
```swift
extension NSTimeZone: Convertible {
    public static func fromMap(_ value: Any) throws -> NSTimeZone {
        guard let name = value as? String else {
            throw MapperError.convertibleError(value: value, expectedType: String.self)
        }
        
        guard let timeZone = self.init(name: name) else {
            throw MapperError.customError(field: nil, message: "Unsupported timezone \(name)")
        }
        
        return timeZone
    }
}
```

## NilConvertible

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

## Mappable

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

struct Object {
    let property: String
    let optionalProperty: String?
    let convertibleProperty: NSTimeZone
    let optionalConvertibleProperty: NSTimeZone?
    let nilConvertibleProperty: NilConvertibleEnum
    let arrayProperty: [String]
    let optionalArrayProperty: [String]?
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
    }
    
    init(map: KeyedMapper<Object>) throws {
        self.property = try map.from(.property)
        self.optionalProperty = map.optionalFrom(.optionalProperty)
        self.convertibleProperty = try map.from(.convertibleProperty)
        self.optionalConvertibleProperty = map.optionalFrom(.optionalConvertibleProperty)
        self.nilConvertibleProperty = try map.from(.nilConvertibleProperty)
        self.arrayProperty = try map.from(.arrayProperty)
        self.optionalArrayProperty = map.optionalFrom(.optionalArrayProperty)
    }
}


let JSON: [AnyHashable : Any] = ["property" : "propertyValue",
                                 "convertibleProperty" : NSTimeZone(forSecondsFromGMT: 0).abbreviation,
                                 "arrayProperty": ["arrayPropertyValue1", "arrayPropertyValue2"]]

let object = try Object.from(JSON: JSON)
```

## ReverseMappable

```swift
extension Object: ReverseMappable {
    func toKeyedJSON() -> [Object.Key : Any?] {
        return [.property : property,
                .optionalProperty : optionalProperty,
                .convertibleProperty : convertibleProperty,
                .optionalConvertibleProperty : optionalConvertibleProperty,
                .nilConvertibleProperty : nilConvertibleProperty,
                .arrayProperty : arrayProperty,
                .optionalArrayProperty : optionalArrayProperty
        ]
    }
}
 
let outJSON = object.toJSON()
```
