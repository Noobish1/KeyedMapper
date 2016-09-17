import UIKit
import CoreLocation
import KeyedMapper

extension CLLocationCoordinate2D: Convertible {
    public static func fromMap(_ value: Any) throws -> CLLocationCoordinate2D {
        guard let latlong = value as? NSDictionary else {
            throw ConvertibleError(value: value, type: NSDictionary.self)
        }
        
        guard let lat = latlong["lat"] as? Double else {
            throw ConvertibleError(value: latlong["lat"], type: Double.self)
        }
        
        guard let long = latlong["lng"] as? Double else {
            throw ConvertibleError(value: latlong["lng"], type: Double.self)
        }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}


let badLatDict: Any = ["lat" : "NotADouble", "lng" : 2.3]

do {
    let _ = try CLLocationCoordinate2D.fromMap(badLatDict)
} catch let error as ConvertibleError {
    print(error.failureReason)
}

let badLngDict: Any = ["lat" : 2.3, "lng" : "NotADouble"]

do {
    let _ = try CLLocationCoordinate2D.fromMap(badLngDict)
} catch let error as ConvertibleError {
    print(error.failureReason)
}

let goodDict: Any = ["lat" : 2.3, "lng" : 4.4]
let coordinate = try CLLocationCoordinate2D.fromMap(goodDict)

print(coordinate)