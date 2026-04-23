import Foundation
import Combine

class EnergyManager: ObservableObject {
    @Published var roofState = RoofState()
    @Published var photovoltaicPanel = PhotovoltaicPanel()
    @Published var batteryState = BatteryState()
    @Published var systemConsumptions: [SystemConsumption] = []
    @Published var energyHistory: [EnergyData] = []

    private var timer: Timer?
    private var roofAnimationTimer: Timer?
    private weak var weatherManager: WeatherManager?

    var totalConsumption: Double {
        systemConsumptions.reduce(0) { $0 + $1.consumption }
    }

    var netEnergy: Double {
        photovoltaicPanel.currentOutput - totalConsumption
    }

    var isSolarSurplus: Bool {
        netEnergy > 0
    }

    init(weatherManager: WeatherManager? = nil) {
        self.weatherManager = weatherManager
        setupInitialState()
        startMonitoring()
    }

    private func setupInitialState() {
        // Initialize system consumptions
        for system in BusSystem.allCases {
            let baseConsumption = system.baseConsumption
            let variation = Double.random(in: 0.8...1.2)
            systemConsumptions.append(
                SystemConsumption(system: system, consumption: baseConsumption * variation)
            )
        }
        updateConsumptionPercentages()
    }

    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.updateEnergy()
            self?.updateBattery()
            self?.recordEnergyData()
        }
    }

    private func updateEnergy() {
        // Update solar generation based on roof position and time of day
        let timeOfDay = Calendar.current.component(.hour, from: Date())
        let sunIntensity: Double

        // Simulate sun intensity (peak at noon)
        if timeOfDay >= 6 && timeOfDay <= 18 {
            let hoursSinceRise = Double(timeOfDay - 6)
            let radiansTime = (hoursSinceRise / 12.0) * .pi
            sunIntensity = sin(radiansTime)
        } else {
            sunIntensity = 0.0
        }

        // Roof must be open for panels to work
        let roofFactor = roofState.openPercentage

        // Weather affects output
        let weatherFactor: Double
        if let weather = weatherManager?.currentWeather {
            switch weather.condition {
            case .sunny:
                weatherFactor = 1.0
            case .partlyCloudy:
                weatherFactor = 0.7
            case .cloudy:
                weatherFactor = 0.4
            case .rainy, .stormy:
                weatherFactor = 0.2
            }
        } else {
            weatherFactor = 0.8
        }

        let maxOutput = photovoltaicPanel.maxOutput
        photovoltaicPanel.currentOutput = maxOutput * sunIntensity * roofFactor * weatherFactor

        // Update total energy generated
        photovoltaicPanel.totalEnergyGenerated += photovoltaicPanel.currentOutput * (3.0 / 3600.0) // kWh

        // Update system consumptions with random variations
        for i in 0..<systemConsumptions.count {
            let base = systemConsumptions[i].system.baseConsumption
            let variation = Double.random(in: 0.9...1.1)
            systemConsumptions[i].consumption = base * variation
        }
        updateConsumptionPercentages()
    }

    private func updateConsumptionPercentages() {
        let total = totalConsumption
        for i in 0..<systemConsumptions.count {
            systemConsumptions[i].percentage = (systemConsumptions[i].consumption / total) * 100
        }
    }

    private func updateBattery() {
        let netPower = netEnergy

        // Update current based on net power
        batteryState.current = netPower / batteryState.voltage * 100 // Convert to amperes (scaled)

        // Update charge level
        let chargeChange = netPower * (3.0 / 3600.0) / batteryState.capacity * 100 // Percentage change
        batteryState.chargeLevel = min(100, max(0, batteryState.chargeLevel + chargeChange))

        // Simulate temperature
        batteryState.temperature = 30 + abs(batteryState.current) * 0.05 + Double.random(in: -1...1)
    }

    private func recordEnergyData() {
        let data = EnergyData(
            timestamp: Date(),
            solarGeneration: photovoltaicPanel.currentOutput,
            totalConsumption: totalConsumption
        )

        energyHistory.append(data)

        // Keep only last 100 data points
        if energyHistory.count > 100 {
            energyHistory.removeFirst()
        }
    }

    // Roof Control Functions
    func openRoof() {
        guard roofState.canOpen else { return }

        // Check weather conditions
        if let weather = weatherManager?.currentWeather, weather.condition.isRaining {
            // Don't open in rain
            return
        }

        roofState.position = .opening
        animateRoofMovement(targetPosition: 1.0) {
            self.roofState.position = .open
        }
    }

    func closeRoof() {
        guard roofState.canClose else { return }

        roofState.position = .closing
        animateRoofMovement(targetPosition: 0.0) {
            self.roofState.position = .closed
        }
    }

    private func animateRoofMovement(targetPosition: Double, completion: @escaping () -> Void) {
        roofAnimationTimer?.invalidate()

        roofAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            let step = 0.05
            if targetPosition > self.roofState.openPercentage {
                // Opening
                self.roofState.openPercentage = min(self.roofState.openPercentage + step, targetPosition)
            } else {
                // Closing
                self.roofState.openPercentage = max(self.roofState.openPercentage - step, targetPosition)
            }

            if abs(self.roofState.openPercentage - targetPosition) < 0.01 {
                self.roofState.openPercentage = targetPosition
                timer.invalidate()
                completion()
            }
        }
    }

    deinit {
        timer?.invalidate()
        roofAnimationTimer?.invalidate()
    }
}
