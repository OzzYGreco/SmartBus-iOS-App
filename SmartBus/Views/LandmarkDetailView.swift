import SwiftUI
import MapKit

struct LandmarkDetailView: View {
    let landmark: Landmark
    @ObservedObject var landmarkManager: LandmarkManager
    @EnvironmentObject var locationSimulator: LocationSimulator
    @State private var showingHelp = false
    @State private var mapRegion: MKCoordinateRegion
    @State private var showFullDescription = false
    @Environment(\.dismiss) private var dismiss

    init(landmark: Landmark, landmarkManager: LandmarkManager) {
        self.landmark = landmark
        self.landmarkManager = landmarkManager
        let center = landmark.coordinate.clCoordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        _mapRegion = State(initialValue: MKCoordinateRegion(center: center, span: span))
    }

    var body: some View {
        ZStack {
            backgroundGradient

            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    infoCardsSection
                    audioPlayerSection
                    descriptionSection
                    mapSection
                    practicalInfoSection
                    navigationButtonsSection
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("")
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingHelp = true }) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showingHelp) {
            HelpView(content: HelpContentProvider.landmarkDetail)
        }
        .onDisappear {
            landmarkManager.stopAudioGuide()
        }
    }

    // MARK: - View Components

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.4, green: 0.6, blue: 1.0),
                Color(red: 0.6, green: 0.4, blue: 0.9),
                Color(red: 0.5, green: 0.5, blue: 1.0)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: landmark.category.icon)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }

            Text(landmark.name)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            HStack(spacing: 12) {
                Label(landmark.category.rawValue, systemImage: landmark.category.icon)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))

                if let period = landmark.historicalPeriod {
                    Text("•")
                        .foregroundColor(.white.opacity(0.5))

                    Text(period)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .padding(.top)
    }

    private var infoCardsSection: some View {
        HStack(spacing: 12) {
            InfoCard(
                icon: "mappin.circle.fill",
                title: "Distance",
                value: String(format: "%.1f km", distance),
                color: .green
            )

            InfoCard(
                icon: "clock.fill",
                title: "Visit Time",
                value: "\(landmark.visitDurationMinutes) min",
                color: .blue
            )

            InfoCard(
                icon: "eurosign.circle.fill",
                title: "Entry Fee",
                value: landmark.entryFee ?? "Free",
                color: .purple
            )
        }
        .padding(.horizontal)
    }

    private var audioPlayerSection: some View {
        AudioPlayerView(landmarkManager: landmarkManager, landmark: landmark)
            .padding(.horizontal)
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(showFullDescription ? landmark.fullDescription : landmark.shortDescription)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)

            if !showFullDescription {
                Button(action: {
                    withAnimation {
                        showFullDescription = true
                    }
                }) {
                    Text("Read More")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }

    private var mapSection: some View {
        let mapView = Map(coordinateRegion: $mapRegion, annotationItems: mapAnnotations) { item in
            MapAnnotation(coordinate: item.coordinate) {
                VStack {
                    Image(systemName: item.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(item.color))
                        .shadow(radius: 3)

                    Text(item.title)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.black.opacity(0.7)))
                }
            }
        }
        .frame(height: 250)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )

        return VStack(alignment: .leading, spacing: 12) {
            Text("Location")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            mapView
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }

    private var practicalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Practical Information")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            VStack(spacing: 12) {
                PracticalInfoRow(icon: "clock.fill", title: "Opening Hours", value: landmark.openingHours)

                if let fee = landmark.entryFee {
                    PracticalInfoRow(icon: "eurosign.circle.fill", title: "Entry Fee", value: fee)
                }

                PracticalInfoRow(icon: "figure.walk", title: "Recommended Duration", value: "\(landmark.visitDurationMinutes) minutes")

                PracticalInfoRow(
                    icon: "mappin.and.ellipse",
                    title: "Distance from Bus",
                    value: String(format: "%.1f km walking distance", distance)
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }

    private var navigationButtonsSection: some View {
        VStack(spacing: 12) {
            NavigationLink(destination: TouristNavigationView(destination: landmark)) {
                HStack(spacing: 10) {
                    Image(systemName: "location.fill.viewfinder")
                        .font(.title3)

                    Text("Get Walking Directions")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color.green, Color.green.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 8)
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                landmarkManager.stopAudioGuide()
                dismiss()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18))

                    Text("Back to Landmarks")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }

    private var distance: Double {
        landmarkManager.distanceToLandmark(from: locationSimulator.currentStop, to: landmark)
    }

    private var mapAnnotations: [LandmarkMapAnnotation] {
        [
            LandmarkMapAnnotation(
                title: "Bus Stop",
                coordinate: locationSimulator.currentStop.coordinate.clCoordinate,
                icon: "bus.fill",
                color: .blue
            ),
            LandmarkMapAnnotation(
                title: landmark.name,
                coordinate: landmark.coordinate.clCoordinate,
                icon: landmark.category.icon,
                color: .red
            )
        ]
    }

    struct LandmarkMapAnnotation: Identifiable {
        let id = UUID()
        let title: String
        let coordinate: CLLocationCoordinate2D
        let icon: String
        let color: Color
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))

            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct PracticalInfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        LandmarkDetailView(landmark: Landmark.athensLandmarks[0], landmarkManager: LandmarkManager())
            .environmentObject(LocationSimulator())
    }
}
