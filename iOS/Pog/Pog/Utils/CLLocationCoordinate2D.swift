import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Hashable {

    var roughLat: Double {
        round(latitude * 100000) / 100000
    }

    var roughLng: Double {
        round(longitude * 100000) / 100000
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(roughLat)
        hasher.combine(roughLng)
    }

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.roughLat == rhs.roughLat && lhs.roughLng == rhs.roughLng
    }
}
