import Foundation
import AVFoundation
import CoreLocation

class LandmarkManager: ObservableObject {
    @Published var landmarks: [Landmark] = Landmark.athensLandmarks
    @Published var selectedCategory: LandmarkCategory? = nil
    @Published var isPlayingAudio = false
    @Published var currentlyPlayingLandmarkId: String? = nil

    private var speechSynthesizer = AVSpeechSynthesizer()
    private var speechDelegate: SpeechDelegate?

    init() {
        speechDelegate = SpeechDelegate(manager: self)
        speechSynthesizer.delegate = speechDelegate
    }

    var filteredLandmarks: [Landmark] {
        if let category = selectedCategory {
            return landmarks.filter { $0.category == category }
        }
        return landmarks
    }

    func nearbyLandmarks(to busStop: BusStop, maxDistanceKm: Double = 1.0) -> [Landmark] {
        return landmarks.filter { landmark in
            let distance = distanceBetween(
                lat1: busStop.coordinate.latitude,
                lon1: busStop.coordinate.longitude,
                lat2: landmark.coordinate.latitude,
                lon2: landmark.coordinate.longitude
            )
            return distance <= maxDistanceKm
        }.sorted { landmark1, landmark2 in
            let dist1 = distanceBetween(
                lat1: busStop.coordinate.latitude,
                lon1: busStop.coordinate.longitude,
                lat2: landmark1.coordinate.latitude,
                lon2: landmark1.coordinate.longitude
            )
            let dist2 = distanceBetween(
                lat1: busStop.coordinate.latitude,
                lon1: busStop.coordinate.longitude,
                lat2: landmark2.coordinate.latitude,
                lon2: landmark2.coordinate.longitude
            )
            return dist1 < dist2
        }
    }

    func distanceToLandmark(from busStop: BusStop, to landmark: Landmark) -> Double {
        return distanceBetween(
            lat1: busStop.coordinate.latitude,
            lon1: busStop.coordinate.longitude,
            lat2: landmark.coordinate.latitude,
            lon2: landmark.coordinate.longitude
        )
    }

    private func distanceBetween(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let coordinate1 = CLLocation(latitude: lat1, longitude: lon1)
        let coordinate2 = CLLocation(latitude: lat2, longitude: lon2)
        return coordinate2.distance(from: coordinate1) / 1000.0 // Convert to km
    }

    // Audio Guide Functions
    func playAudioGuide(for landmark: Landmark) {
        if isPlayingAudio && currentlyPlayingLandmarkId == landmark.id {
            stopAudioGuide()
            return
        }

        stopAudioGuide()

        let utterance = AVSpeechUtterance(string: landmark.audioScript)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5 // Slightly slower for clarity
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0

        currentlyPlayingLandmarkId = landmark.id
        isPlayingAudio = true

        speechSynthesizer.speak(utterance)
    }

    func stopAudioGuide() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        isPlayingAudio = false
        currentlyPlayingLandmarkId = nil
    }

    func pauseAudioGuide() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: .word)
        }
    }

    func resumeAudioGuide() {
        if speechSynthesizer.isPaused {
            speechSynthesizer.continueSpeaking()
        }
    }
}

// Speech Synthesizer Delegate
private class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    weak var manager: LandmarkManager?

    init(manager: LandmarkManager) {
        self.manager = manager
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.manager?.isPlayingAudio = false
            self.manager?.currentlyPlayingLandmarkId = nil
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.manager?.isPlayingAudio = false
            self.manager?.currentlyPlayingLandmarkId = nil
        }
    }
}
