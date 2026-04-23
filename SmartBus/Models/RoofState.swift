import Foundation

enum RoofPosition: String {
    case closed = "Closed"
    case opening = "Opening"
    case open = "Open"
    case closing = "Closing"

    var icon: String {
        switch self {
        case .closed: return "rectangle.fill"
        case .opening: return "rectangle.lefthalf.filled"
        case .open: return "rectangle"
        case .closing: return "rectangle.righthalf.filled"
        }
    }

    var progress: Double {
        switch self {
        case .closed: return 0.0
        case .opening: return 0.5
        case .open: return 1.0
        case .closing: return 0.5
        }
    }
}

struct RoofState {
    var position: RoofPosition = .closed
    var openPercentage: Double = 0.0 // 0.0 = fully closed, 1.0 = fully open
    var isMoving: Bool {
        position == .opening || position == .closing
    }

    var canOpen: Bool {
        position == .closed
    }

    var canClose: Bool {
        position == .open
    }
}

struct PhotovoltaicPanel {
    var currentOutput: Double = 0.0 // kW
    var maxOutput: Double = 15.0 // kW
    var totalEnergyGenerated: Double = 0.0 // kWh
    var efficiency: Double {
        guard maxOutput > 0 else { return 0 }
        return (currentOutput / maxOutput) * 100
    }

    var status: String {
        if currentOutput < maxOutput * 0.3 {
            return "Low"
        } else if currentOutput < maxOutput * 0.7 {
            return "Medium"
        } else {
            return "High"
        }
    }
}
