import Foundation
import CoreLocation

struct BusStop: Identifiable, Codable {
    let id: String
    let name: String
    let coordinate: Coordinate
    let landmarkIds: [String] // IDs of nearby landmarks
    let estimatedArrivalMinutes: Int // Minutes from start of route

    struct Coordinate: Codable {
        let latitude: Double
        let longitude: Double

        var clCoordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}

// Athens bus route stops
extension BusStop {
    static let athensRoute: [BusStop] = [
        BusStop(
            id: "stop1",
            name: "Syntagma Square",
            coordinate: Coordinate(latitude: 37.9755, longitude: 23.7348),
            landmarkIds: ["syntagma", "parliament"],
            estimatedArrivalMinutes: 0
        ),
        BusStop(
            id: "stop2",
            name: "Plaka District",
            coordinate: Coordinate(latitude: 37.9722, longitude: 23.7275),
            landmarkIds: ["plaka", "ancient-agora"],
            estimatedArrivalMinutes: 8
        ),
        BusStop(
            id: "stop3",
            name: "Acropolis Entrance",
            coordinate: Coordinate(latitude: 37.9715, longitude: 23.7257),
            landmarkIds: ["acropolis", "parthenon"],
            estimatedArrivalMinutes: 15
        ),
        BusStop(
            id: "stop4",
            name: "Acropolis Museum",
            coordinate: Coordinate(latitude: 37.9688, longitude: 23.7282),
            landmarkIds: ["acropolis-museum"],
            estimatedArrivalMinutes: 22
        ),
        BusStop(
            id: "stop5",
            name: "Temple of Zeus",
            coordinate: Coordinate(latitude: 37.9692, longitude: 23.7331),
            landmarkIds: ["temple-zeus"],
            estimatedArrivalMinutes: 30
        ),
        BusStop(
            id: "stop6",
            name: "Panathenaic Stadium",
            coordinate: Coordinate(latitude: 37.9683, longitude: 23.7408),
            landmarkIds: ["panathenaic-stadium"],
            estimatedArrivalMinutes: 38
        ),
        BusStop(
            id: "stop7",
            name: "National Gardens",
            coordinate: Coordinate(latitude: 37.9741, longitude: 23.7378),
            landmarkIds: ["national-gardens"],
            estimatedArrivalMinutes: 45
        ),
        BusStop(
            id: "stop8",
            name: "Monastiraki Square",
            coordinate: Coordinate(latitude: 37.9762, longitude: 23.7254),
            landmarkIds: ["monastiraki", "ancient-agora"],
            estimatedArrivalMinutes: 53
        ),
        BusStop(
            id: "stop9",
            name: "National Archaeological Museum",
            coordinate: Coordinate(latitude: 37.9891, longitude: 23.7322),
            landmarkIds: ["archaeological-museum"],
            estimatedArrivalMinutes: 65
        ),
        BusStop(
            id: "stop10",
            name: "Lycabettus Hill Base",
            coordinate: Coordinate(latitude: 37.9812, longitude: 23.7423),
            landmarkIds: ["lycabettus"],
            estimatedArrivalMinutes: 73
        ),
        BusStop(
            id: "stop11",
            name: "Kolonaki Square",
            coordinate: Coordinate(latitude: 37.9794, longitude: 23.7406),
            landmarkIds: [],
            estimatedArrivalMinutes: 80
        ),
        BusStop(
            id: "stop12",
            name: "Return to Syntagma",
            coordinate: Coordinate(latitude: 37.9755, longitude: 23.7348),
            landmarkIds: ["syntagma"],
            estimatedArrivalMinutes: 90
        )
    ]
}
