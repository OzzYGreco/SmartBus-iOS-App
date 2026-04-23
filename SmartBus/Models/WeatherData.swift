import Foundation

enum WeatherCondition: String {
    case sunny = "Sunny"
    case partlyCloudy = "Partly Cloudy"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    case stormy = "Stormy"

    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .rainy: return "cloud.rain.fill"
        case .stormy: return "cloud.bolt.fill"
        }
    }

    var color: String {
        switch self {
        case .sunny: return "yellow"
        case .partlyCloudy: return "orange"
        case .cloudy: return "gray"
        case .rainy: return "blue"
        case .stormy: return "purple"
        }
    }

    var isRaining: Bool {
        self == .rainy || self == .stormy
    }
}

struct WeatherData {
    var temperature: Double = 25.0
    var humidity: Int = 60
    var condition: WeatherCondition = .sunny
    var windSpeed: Double = 10.0 // km/h
    var feelsLike: Double {
        // Simplified heat index calculation
        if temperature >= 27 {
            return temperature + Double(humidity - 40) / 20
        }
        return temperature - (windSpeed / 10)
    }

    var recommendedMode: ClimateMode {
        if temperature > 26 {
            return .cooling
        } else if temperature < 18 {
            return .heating
        }
        return .auto
    }

    var recommendedTemperature: Double {
        if temperature > 26 {
            return 22.0
        } else if temperature < 18 {
            return 24.0
        }
        return 23.0
    }
}
