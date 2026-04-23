import SwiftUI

struct LandmarksView: View {
    @StateObject private var landmarkManager = LandmarkManager()
    @EnvironmentObject var locationSimulator: LocationSimulator
    @State private var showingHelp = false
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    var filteredLandmarks: [Landmark] {
        var result = landmarkManager.filteredLandmarks

        if !searchText.isEmpty {
            result = result.filter { landmark in
                landmark.name.localizedCaseInsensitiveContains(searchText) ||
                landmark.shortDescription.localizedCaseInsensitiveContains(searchText) ||
                landmark.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Sort by distance from current bus stop
        return result.sorted { landmark1, landmark2 in
            let dist1 = landmarkManager.distanceToLandmark(from: locationSimulator.currentStop, to: landmark1)
            let dist2 = landmarkManager.distanceToLandmark(from: locationSimulator.currentStop, to: landmark2)
            return dist1 < dist2
        }
    }

    var body: some View {
        ZStack {
            // Background gradient
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

            VStack(spacing: 0) {
                // Current location banner
                HStack {
                    Image(systemName: "location.fill")
                        .font(.title3)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current Stop")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))

                        Text(locationSimulator.currentStop.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }

                    Spacer()

                    Text("\(nearbyCount) nearby")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.green.opacity(0.3))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal)
                .padding(.top)

                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))

                    TextField("Search landmarks...", text: $searchText)
                        .foregroundColor(.white)
                        .tint(.white)

                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal)
                .padding(.top, 12)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryFilterButton(
                            title: "All",
                            icon: "list.bullet",
                            isSelected: landmarkManager.selectedCategory == nil,
                            action: { landmarkManager.selectedCategory = nil }
                        )

                        ForEach(LandmarkCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
                                title: category.rawValue,
                                icon: category.icon,
                                isSelected: landmarkManager.selectedCategory == category,
                                action: { landmarkManager.selectedCategory = category }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)

                // Landmarks list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredLandmarks) { landmark in
                            NavigationLink(destination: LandmarkDetailView(landmark: landmark, landmarkManager: landmarkManager)) {
                                LandmarkCardView(landmark: landmark, currentStop: locationSimulator.currentStop, landmarkManager: landmarkManager)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()

                    // Home button
                    Button(action: {
                        landmarkManager.stopAudioGuide()
                        dismiss()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 18))

                            Text("Home")
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
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Nearby Landmarks")
                    .font(.headline)
                    .foregroundColor(.white)
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
            HelpView(content: HelpContentProvider.landmarks)
        }
        .onDisappear {
            landmarkManager.stopAudioGuide()
        }
    }

    private var nearbyCount: Int {
        landmarkManager.nearbyLandmarks(to: locationSimulator.currentStop, maxDistanceKm: 1.0).count
    }
}

struct CategoryFilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ?
                          Color.white.opacity(0.3) :
                          Color.white.opacity(0.1))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

struct LandmarkCardView: View {
    let landmark: Landmark
    let currentStop: BusStop
    let landmarkManager: LandmarkManager

    private var distance: Double {
        landmarkManager.distanceToLandmark(from: currentStop, to: landmark)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(landmark.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    HStack(spacing: 8) {
                        Image(systemName: landmark.category.icon)
                            .font(.caption)

                        Text(landmark.category.rawValue)
                            .font(.caption)
                    }
                    .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)

                        Text(String(format: "%.1f km", distance))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.green)

                    Text("\(landmark.visitDurationMinutes) min visit")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            Text(landmark.shortDescription)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(2)

            HStack {
                if let period = landmark.historicalPeriod {
                    Label(period, systemImage: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
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
        .shadow(color: .black.opacity(0.1), radius: 8)
    }
}

#Preview {
    NavigationStack {
        LandmarksView()
            .environmentObject(LocationSimulator())
    }
}
