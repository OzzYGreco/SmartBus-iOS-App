import SwiftUI

struct AudioPlayerView: View {
    @ObservedObject var landmarkManager: LandmarkManager
    let landmark: Landmark

    var isPlayingThis: Bool {
        landmarkManager.currentlyPlayingLandmarkId == landmark.id && landmarkManager.isPlayingAudio
    }

    var body: some View {
        Button(action: {
            landmarkManager.playAudioGuide(for: landmark)
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(isPlayingThis ?
                              LinearGradient(colors: [Color.green, Color.green.opacity(0.7)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing) :
                              LinearGradient(colors: [Color.blue, Color.blue.opacity(0.7)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 50, height: 50)

                    Image(systemName: isPlayingThis ? "stop.fill" : "play.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(isPlayingThis ? "Playing Audio Guide" : "Play Audio Guide")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Listen to detailed narration")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                if isPlayingThis {
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Capsule()
                                .fill(Color.white)
                                .frame(width: 3, height: 20)
                                .scaleEffect(y: animatedScale)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: animatedScale
                                )
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 8)
        }
        .buttonStyle(PlainButtonStyle())
    }

    @State private var animatedScale: CGFloat = 1.0

    init(landmarkManager: LandmarkManager, landmark: Landmark) {
        self.landmarkManager = landmarkManager
        self.landmark = landmark
        _animatedScale = State(initialValue: CGFloat.random(in: 0.5...1.5))
    }
}
