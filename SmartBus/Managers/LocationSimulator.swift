import Foundation
import CoreLocation
import Combine

class LocationSimulator: ObservableObject {
    @Published var currentStop: BusStop
    @Published var nextStop: BusStop
    @Published var currentSpeed: Double = 0 // km/h
    @Published var progressToNextStop: Double = 0 // 0.0 to 1.0
    @Published var routeElapsedMinutes: Int = 0

    private let route: BusRoute
    private var timer: Timer?
    private var currentStopIndex: Int = 0
    private let updateIntervalSeconds: TimeInterval = 2.0 // Update every 2 seconds

    init(route: BusRoute = .athensRoute) {
        self.route = route
        self.currentStop = route.stops[0]
        self.nextStop = route.stops[1]
        startSimulation()
    }

    private func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: updateIntervalSeconds, repeats: true) { [weak self] _ in
            self?.updateLocation()
        }
    }

    private func updateLocation() {
        // Simulate progress toward next stop
        progressToNextStop += 0.05 // 5% progress every 2 seconds (~40 seconds per segment)

        // Vary speed realistically
        let baseSpeed = route.averageSpeedKmh
        currentSpeed = baseSpeed + Double.random(in: -5...10) // Vary ±5-10 km/h

        // Simulate stop-and-go traffic
        if progressToNextStop > 0.9 {
            currentSpeed = max(10, currentSpeed - 15) // Slow down approaching stop
        }

        // Update elapsed time
        routeElapsedMinutes += Int(updateIntervalSeconds / 60)

        // Move to next stop when progress complete
        if progressToNextStop >= 1.0 {
            moveToNextStop()
        }
    }

    private func moveToNextStop() {
        progressToNextStop = 0.0
        currentStopIndex += 1

        // Loop back to start
        if currentStopIndex >= route.stops.count {
            currentStopIndex = 0
            routeElapsedMinutes = 0
        }

        currentStop = route.stops[currentStopIndex]

        // Set next stop (with wrap-around)
        let nextIndex = (currentStopIndex + 1) % route.stops.count
        nextStop = route.stops[nextIndex]
    }

    func distanceToStop(stopId: String) -> Double {
        guard let stopIndex = route.stops.firstIndex(where: { $0.id == stopId }) else {
            return 0
        }

        if stopIndex == currentStopIndex {
            return 0
        }

        // Calculate approximate distance in km
        let stopsAway = route.stopsBetween(currentStopId: currentStop.id, destinationStopId: stopId)
        let averageStopDistanceKm = 1.5 // Approximate average distance between stops
        return Double(stopsAway) * averageStopDistanceKm * (1.0 - progressToNextStop)
    }

    func minutesToStop(stopId: String) -> Int {
        let baseMinutes = route.estimatedMinutes(from: currentStop.id, to: stopId)
        // Adjust for current progress
        let progressAdjustment = Int((1.0 - progressToNextStop) * 8) // ~8 min between stops
        return max(0, baseMinutes - progressAdjustment)
    }

    deinit {
        timer?.invalidate()
    }
}
