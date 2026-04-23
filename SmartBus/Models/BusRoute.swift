import Foundation
import CoreLocation

struct BusRoute {
    let stops: [BusStop]
    let totalDurationMinutes: Int
    let averageSpeedKmh: Double

    static let athensRoute = BusRoute(
        stops: BusStop.athensRoute,
        totalDurationMinutes: 90,
        averageSpeedKmh: 25.0
    )

    func nextStop(after currentStopId: String) -> BusStop? {
        guard let currentIndex = stops.firstIndex(where: { $0.id == currentStopId }),
              currentIndex < stops.count - 1 else {
            return stops.first // Loop back to start
        }
        return stops[currentIndex + 1]
    }

    func stopsBetween(currentStopId: String, destinationStopId: String) -> Int {
        guard let currentIndex = stops.firstIndex(where: { $0.id == currentStopId }),
              let destinationIndex = stops.firstIndex(where: { $0.id == destinationStopId }) else {
            return 0
        }

        if destinationIndex >= currentIndex {
            return destinationIndex - currentIndex
        } else {
            // Wrap around
            return (stops.count - currentIndex) + destinationIndex
        }
    }

    func estimatedMinutes(from currentStopId: String, to destinationStopId: String) -> Int {
        guard let currentIndex = stops.firstIndex(where: { $0.id == currentStopId }),
              let destinationIndex = stops.firstIndex(where: { $0.id == destinationStopId }) else {
            return 0
        }

        let currentTime = stops[currentIndex].estimatedArrivalMinutes
        let destinationTime = stops[destinationIndex].estimatedArrivalMinutes

        if destinationTime >= currentTime {
            return destinationTime - currentTime
        } else {
            // Wrap around the route
            return (totalDurationMinutes - currentTime) + destinationTime
        }
    }
}
