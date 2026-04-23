import Foundation

enum ClimateMode: String, CaseIterable {
    case auto = "Auto"
    case cooling = "Cooling"
    case heating = "Heating"
    case off = "Off"

    var icon: String {
        switch self {
        case .auto: return "arrow.triangle.2.circlepath"
        case .cooling: return "snowflake"
        case .heating: return "flame.fill"
        case .off: return "power"
        }
    }

    var color: String {
        switch self {
        case .auto: return "green"
        case .cooling: return "blue"
        case .heating: return "orange"
        case .off: return "gray"
        }
    }
}

enum FanSpeed: Int, CaseIterable {
    case off = 0
    case low = 1
    case medium = 2
    case high = 3

    var label: String {
        switch self {
        case .off: return "Off"
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }

    var icon: String {
        switch self {
        case .off: return "fan"
        case .low: return "fan.fill"
        case .medium: return "fan.fill"
        case .high: return "fan.fill"
        }
    }
}

struct ClimateSettings {
    var mode: ClimateMode = .auto
    var targetTemperature: Double = 22.0 // Celsius
    var fanSpeed: FanSpeed = .medium
    var currentTemperature: Double = 25.0
    var outdoorTemperature: Double = 28.0

    var isActive: Bool {
        mode != .off && fanSpeed != .off
    }

    var temperatureRange: ClosedRange<Double> {
        16.0...30.0
    }
}
