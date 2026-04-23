import Foundation

enum SafetyAlertType: String {
    case speedLimit = "Speed Limit Exceeded"
    case laneDeparture = "Lane Departure Warning"
    case fatigue = "Fatigue Detected"
    case passengerBoarding = "Passengers Still Boarding"

    var icon: String {
        switch self {
        case .speedLimit: return "speedometer"
        case .laneDeparture: return "road.lanes"
        case .fatigue: return "bed.double.fill"
        case .passengerBoarding: return "figure.walk.motion"
        }
    }

    var color: String {
        switch self {
        case .speedLimit: return "red"
        case .laneDeparture: return "orange"
        case .fatigue: return "yellow"
        case .passengerBoarding: return "blue"
        }
    }

    var message: String {
        switch self {
        case .speedLimit:
            return "Please reduce speed to within the limit"
        case .laneDeparture:
            return "Vehicle is drifting from lane. Please correct steering"
        case .fatigue:
            return "You may be tired. Would you like a coffee break?"
        case .passengerBoarding:
            return "Wait! Passengers are still boarding. Do not close doors"
        }
    }

    var priority: Int {
        switch self {
        case .passengerBoarding: return 4
        case .speedLimit: return 3
        case .laneDeparture: return 2
        case .fatigue: return 1
        }
    }
}

struct DrivingMetrics {
    var currentSpeed: Double = 0
    var speedLimit: Double = 50
    var lanePosition: Double = 0.5 // 0 = left edge, 0.5 = center, 1 = right edge
    var fatigueLevel: Double = 0 // 0 = fresh, 1 = exhausted
    var drivingDurationMinutes: Int = 0
    var passengersBoarding: Bool = false

    var isSpeedingExcess: Bool {
        currentSpeed > speedLimit + 5
    }

    var isOutOfLane: Bool {
        lanePosition < 0.3 || lanePosition > 0.7
    }

    var isFatigued: Bool {
        fatigueLevel > 0.7
    }
}
