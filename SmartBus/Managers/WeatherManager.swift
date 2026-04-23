import Foundation
import Combine

class WeatherManager: ObservableObject {
    @Published var currentWeather = WeatherData()
    @Published var climateSettings = ClimateSettings()

    private var timer: Timer?

    init() {
        setupInitialWeather()
        startWeatherSimulation()
        applyAutoClimate()
    }

    private func setupInitialWeather() {
        // Simulate Athens summer weather
        currentWeather.temperature = 28.0
        currentWeather.humidity = 55
        currentWeather.condition = .sunny
        currentWeather.windSpeed = 12.0

        climateSettings.outdoorTemperature = currentWeather.temperature
        climateSettings.currentTemperature = 25.0
    }

    private func startWeatherSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.updateWeather()
            self?.updateIndoorTemperature()
        }
    }

    private func updateWeather() {
        // Simulate gradual weather changes
        currentWeather.temperature += Double.random(in: -0.5...0.5)
        currentWeather.temperature = max(20, min(35, currentWeather.temperature))

        currentWeather.humidity += Int.random(in: -2...2)
        currentWeather.humidity = max(30, min(80, currentWeather.humidity))

        currentWeather.windSpeed += Double.random(in: -2...2)
        currentWeather.windSpeed = max(0, min(30, currentWeather.windSpeed))

        // Occasional weather condition changes
        if Double.random(in: 0...1) < 0.05 {
            let conditions: [WeatherCondition] = [.sunny, .partlyCloudy, .cloudy]
            currentWeather.condition = conditions.randomElement() ?? .sunny
        }

        climateSettings.outdoorTemperature = currentWeather.temperature
    }

    private func updateIndoorTemperature() {
        guard climateSettings.isActive else {
            // No climate control - indoor temp approaches outdoor
            let difference = climateSettings.outdoorTemperature - climateSettings.currentTemperature
            climateSettings.currentTemperature += difference * 0.1
            return
        }

        // Climate control is active - move toward target
        let difference = climateSettings.targetTemperature - climateSettings.currentTemperature

        // Speed depends on fan speed and mode
        let coolingRate: Double
        switch climateSettings.fanSpeed {
        case .off:
            coolingRate = 0.0
        case .low:
            coolingRate = 0.1
        case .medium:
            coolingRate = 0.2
        case .high:
            coolingRate = 0.3
        }

        climateSettings.currentTemperature += difference * coolingRate
    }

    func applyAutoClimate() {
        if climateSettings.mode == .auto {
            climateSettings.targetTemperature = currentWeather.recommendedTemperature

            if climateSettings.currentTemperature > climateSettings.targetTemperature + 2 {
                climateSettings.mode = .cooling
            } else if climateSettings.currentTemperature < climateSettings.targetTemperature - 2 {
                climateSettings.mode = .heating
            }
        }
    }

    func setMode(_ mode: ClimateMode) {
        climateSettings.mode = mode
        if mode == .auto {
            applyAutoClimate()
        }
    }

    func setTargetTemperature(_ temperature: Double) {
        climateSettings.targetTemperature = min(
            max(temperature, climateSettings.temperatureRange.lowerBound),
            climateSettings.temperatureRange.upperBound
        )
    }

    func setFanSpeed(_ speed: FanSpeed) {
        climateSettings.fanSpeed = speed
    }

    deinit {
        timer?.invalidate()
    }
}
