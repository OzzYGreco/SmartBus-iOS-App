import Foundation

enum BusSystem: String, CaseIterable {
    case propulsion = "Propulsion"
    case climate = "Climate Control"
    case lighting = "Lighting"
    case vacuum = "Vacuum Robot"
    case displays = "Passenger Displays"
    case other = "Other Systems"

    var icon: String {
        switch self {
        case .propulsion: return "car.fill"
        case .climate: return "thermometer.medium"
        case .lighting: return "lightbulb.fill"
        case .vacuum: return "wind"
        case .displays: return "tv.fill"
        case .other: return "gearshape.fill"
        }
    }

    var color: String {
        switch self {
        case .propulsion: return "blue"
        case .climate: return "orange"
        case .lighting: return "yellow"
        case .vacuum: return "purple"
        case .displays: return "green"
        case .other: return "gray"
        }
    }

    var baseConsumption: Double {
        switch self {
        case .propulsion: return 25.0 // kW
        case .climate: return 8.0
        case .lighting: return 2.0
        case .vacuum: return 1.5
        case .displays: return 1.0
        case .other: return 2.5
        }
    }
}

struct SystemConsumption {
    let system: BusSystem
    var consumption: Double // kW

    var percentage: Double = 0.0 // Will be calculated

    init(system: BusSystem, consumption: Double) {
        self.system = system
        self.consumption = consumption
    }
}

struct BatteryState {
    var chargeLevel: Double = 75.0 // Percentage
    var capacity: Double = 200.0 // kWh
    var voltage: Double = 400.0 // V
    var current: Double = 0.0 // A (negative = discharging, positive = charging)
    var temperature: Double = 35.0 // Celsius

    var remainingEnergy: Double {
        (chargeLevel / 100.0) * capacity
    }

    var isCharging: Bool {
        current > 0
    }

    var isDischarging: Bool {
        current < 0
    }

    var health: String {
        if chargeLevel > 70 {
            return "Excellent"
        } else if chargeLevel > 40 {
            return "Good"
        } else if chargeLevel > 20 {
            return "Low"
        } else {
            return "Critical"
        }
    }

    var healthColor: String {
        if chargeLevel > 70 {
            return "green"
        } else if chargeLevel > 40 {
            return "yellow"
        } else if chargeLevel > 20 {
            return "orange"
        } else {
            return "red"
        }
    }

    var estimatedRangeHours: Double {
        let averageConsumption = 40.0 // kW average
        return remainingEnergy / averageConsumption
    }
}

struct EnergyData {
    let timestamp: Date
    let solarGeneration: Double // kW
    let totalConsumption: Double // kW
}
