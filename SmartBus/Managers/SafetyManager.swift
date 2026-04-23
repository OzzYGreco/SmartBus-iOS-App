import Foundation
import AVFoundation
import Combine

class SafetyManager: ObservableObject {
    @Published var currentMetrics = DrivingMetrics()
    @Published var activeAlerts: [SafetyAlertType] = []
    @Published var alertHistory: [(date: Date, alert: SafetyAlertType)] = []

    private var timer: Timer?
    private let synthesizer = AVSpeechSynthesizer()
    private var lastAlertTime: [SafetyAlertType: Date] = [:]
    private let alertCooldownSeconds: TimeInterval = 10

    init() {
        startMonitoring()
    }

    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateMetrics()
            self?.checkForAlerts()
        }
    }

    private func updateMetrics() {
        // Simulate realistic driving metrics
        currentMetrics.drivingDurationMinutes += 1

        // Simulate speed variations
        let baseSpeed = 40.0
        currentMetrics.currentSpeed = baseSpeed + Double.random(in: -10...20)

        // Randomly change speed limit at "different zones"
        if Int.random(in: 0...30) == 0 {
            currentMetrics.speedLimit = [30.0, 40.0, 50.0].randomElement()!
        }

        // Simulate occasional lane drift
        if Double.random(in: 0...1) < 0.1 {
            currentMetrics.lanePosition = Double.random(in: 0.2...0.8)
        } else {
            currentMetrics.lanePosition = 0.5 // Centered
        }

        // Fatigue increases over time, resets after coffee break
        currentMetrics.fatigueLevel = min(1.0, Double(currentMetrics.drivingDurationMinutes) / 120.0)

        // Random passenger boarding events at simulated stops
        if Int.random(in: 0...50) == 0 {
            currentMetrics.passengersBoarding = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.currentMetrics.passengersBoarding = false
            }
        }
    }

    private func checkForAlerts() {
        var newAlerts: [SafetyAlertType] = []

        // Check speeding
        if currentMetrics.isSpeedingExcess {
            newAlerts.append(.speedLimit)
        }

        // Check lane departure
        if currentMetrics.isOutOfLane {
            newAlerts.append(.laneDeparture)
        }

        // Check fatigue
        if currentMetrics.isFatigued {
            newAlerts.append(.fatigue)
        }

        // Check passenger boarding
        if currentMetrics.passengersBoarding {
            newAlerts.append(.passengerBoarding)
        }

        // Update active alerts
        for alert in newAlerts {
            if !activeAlerts.contains(alert) {
                addAlert(alert)
            }
        }

        // Remove alerts that are no longer active
        activeAlerts.removeAll { alert in
            !newAlerts.contains(alert)
        }
    }

    private func addAlert(_ alert: SafetyAlertType) {
        // Check cooldown to avoid spamming
        if let lastTime = lastAlertTime[alert],
           Date().timeIntervalSince(lastTime) < alertCooldownSeconds {
            return
        }

        activeAlerts.append(alert)
        alertHistory.append((date: Date(), alert: alert))
        lastAlertTime[alert] = Date()

        // Play audio alert for high-priority alerts
        if alert.priority >= 3 {
            playAlertSound(for: alert)
        }

        // Keep history to max 50 items
        if alertHistory.count > 50 {
            alertHistory.removeFirst()
        }
    }

    func dismissAlert(_ alert: SafetyAlertType) {
        activeAlerts.removeAll { $0 == alert }

        // Special handling for fatigue - simulate coffee break
        if alert == .fatigue {
            currentMetrics.fatigueLevel = 0
            currentMetrics.drivingDurationMinutes = 0
        }
    }

    func dismissAllAlerts() {
        activeAlerts.removeAll()
    }

    private func playAlertSound(for alert: SafetyAlertType) {
        let utterance = AVSpeechUtterance(string: alert.message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.volume = 1.0

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        synthesizer.speak(utterance)
    }

    deinit {
        timer?.invalidate()
    }
}
