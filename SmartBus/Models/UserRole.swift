import Foundation

enum UserRole: String, Codable {
    case passenger = "Passenger"
    case driver = "Driver"
    case employee = "Employee"

    var displayName: String {
        return self.rawValue
    }

    var icon: String {
        switch self {
        case .passenger: return "person.fill"
        case .driver: return "steering.wheel"
        case .employee: return "briefcase.fill"
        }
    }

    // Define which features each role can access
    var availableFeatures: Set<AppFeature> {
        switch self {
        case .passenger:
            // Passengers: Only 3 features (Driver's View, Landmarks, Coffee Orders)
            return [.driverView, .landmarks, .coffeeOrder]
        case .driver:
            // Driver: All passenger features + Driver Assist + Climate + Vacuum Robot (6 features)
            return [.driverView, .landmarks, .coffeeOrder, .driverAssist, .climate, .vacuum]
        case .employee:
            // Employee: All driver features + Roof Control + Energy Dashboard (8 features)
            return [.driverView, .landmarks, .coffeeOrder, .driverAssist, .climate, .vacuum, .roofControl, .energy]
        }
    }
}

enum AppFeature: String, CaseIterable {
    case driverView = "Driver's View"
    case landmarks = "Landmarks"
    case coffeeOrder = "Order Coffee"
    case vacuum = "Vacuum"
    case driverAssist = "Driver Assist"
    case climate = "Climate"
    case roofControl = "Roof Control"
    case energy = "Energy"

    var icon: String {
        switch self {
        case .driverView: return "car.fill"
        case .landmarks: return "building.columns.fill"
        case .coffeeOrder: return "cup.and.saucer.fill"
        case .vacuum: return "wind"
        case .driverAssist: return "shield.checkered"
        case .climate: return "thermometer.medium"
        case .roofControl: return "rectangle.on.rectangle"
        case .energy: return "bolt.batteryblock"
        }
    }
}
