import SwiftUI
import MapKit

struct TouristNavigationView: View {
    let destination: Landmark
    @EnvironmentObject var locationSimulator: LocationSimulator
    @State private var showingHelp = false
    @State private var mapRegion: MKCoordinateRegion
    @State private var showingDirections = false
    @Environment(\.dismiss) private var dismiss

    init(destination: Landmark) {
        self.destination = destination
        _mapRegion = State(initialValue: MKCoordinateRegion(
            center: destination.coordinate.clCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        ))
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
                // Header
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "location.fill.viewfinder")
                            .font(.title)

                        VStack(alignment: .leading) {
                            Text("Walking to")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))

                            Text(destination.name)
                                .font(.headline)
                                .fontWeight(.bold)
                        }

                        Spacer()

                        VStack(alignment: .trailing) {
                            Text("\(estimatedWalkingMinutes) min")
                                .font(.title3)
                                .fontWeight(.bold)

                            Text(String(format: "%.1f km", distance))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .foregroundColor(.white)
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
                .padding()

                // Map with route
                Map(coordinateRegion: $mapRegion, annotationItems: routePoints) { point in
                    MapAnnotation(coordinate: point.coordinate) {
                        VStack {
                            Image(systemName: point.icon)
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(point.color)
                                )
                                .shadow(radius: 3)

                            Text(point.label)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(
                                    Capsule()
                                        .fill(Color.black.opacity(0.7))
                                )
                        }
                    }
                }
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)

                // Directions button
                if !showingDirections {
                    Button(action: {
                        withAnimation {
                            showingDirections = true
                        }
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "list.bullet")
                                .font(.title3)

                            Text("Show Step-by-Step Directions")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue, Color.blue.opacity(0.8)],
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
                    .padding(.horizontal)
                    .padding(.top)
                }

                // Turn-by-turn directions
                if showingDirections {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Directions")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            ForEach(Array(navigationSteps.enumerated()), id: \.offset) { index, step in
                                NavigationStepRow(step: step, stepNumber: index + 1)
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
                        .padding(.top)
                    }
                }

                Spacer()

                // Nearby bus stops button
                NavigationLink(destination: NearbyBusStopsView()) {
                    HStack(spacing: 10) {
                        Image(systemName: "bus.fill")
                            .font(.title3)

                        Text("Find Nearest Bus Stop")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.purple.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)

                // Back button
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18))

                        Text("Back")
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Walking Navigation")
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
            HelpView(content: HelpContentProvider.touristNavigation)
        }
    }

    private var distance: Double {
        let start = CLLocation(
            latitude: locationSimulator.currentStop.coordinate.latitude,
            longitude: locationSimulator.currentStop.coordinate.longitude
        )
        let end = CLLocation(
            latitude: destination.coordinate.latitude,
            longitude: destination.coordinate.longitude
        )
        return end.distance(from: start) / 1000.0
    }

    private var estimatedWalkingMinutes: Int {
        Int((distance * 1000) / 80) // Assume 80 meters per minute walking speed
    }

    private var routePoints: [RoutePoint] {
        [
            RoutePoint(
                label: "You are here",
                coordinate: locationSimulator.currentStop.coordinate.clCoordinate,
                icon: "figure.walk",
                color: .blue
            ),
            RoutePoint(
                label: destination.name,
                coordinate: destination.coordinate.clCoordinate,
                icon: "mappin.circle.fill",
                color: .red
            )
        ]
    }

    private var navigationSteps: [NavigationStep] {
        [
            NavigationStep(
                instruction: "Head south from \(locationSimulator.currentStop.name)",
                distance: Int(distance * 300),
                icon: "arrow.down"
            ),
            NavigationStep(
                instruction: "Turn right onto the main street",
                distance: Int(distance * 200),
                icon: "arrow.turn.up.right"
            ),
            NavigationStep(
                instruction: "Continue straight for several blocks",
                distance: Int(distance * 400),
                icon: "arrow.up"
            ),
            NavigationStep(
                instruction: "Turn left when you see the landmark",
                distance: Int(distance * 100),
                icon: "arrow.turn.up.left"
            ),
            NavigationStep(
                instruction: "Arrive at \(destination.name)",
                distance: 0,
                icon: "checkmark.circle.fill"
            )
        ]
    }

    struct RoutePoint: Identifiable {
        let id = UUID()
        let label: String
        let coordinate: CLLocationCoordinate2D
        let icon: String
        let color: Color
    }

    struct NavigationStep {
        let instruction: String
        let distance: Int
        let icon: String
    }
}

struct NavigationStepRow: View {
    let step: TouristNavigationView.NavigationStep
    let stepNumber: Int

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 40, height: 40)

                Text("\(stepNumber)")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: step.icon)
                        .font(.body)
                        .foregroundColor(.blue)

                    Text(step.instruction)
                        .font(.body)
                        .foregroundColor(.white)
                }

                if step.distance > 0 {
                    Text("\(step.distance) meters")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            Spacer()
        }
    }
}

struct NearbyBusStopsView: View {
    @EnvironmentObject var locationSimulator: LocationSimulator
    @State private var showingHelp = false
    @Environment(\.dismiss) private var dismiss

    private var nearbyStops: [BusStop] {
        let allStops = BusStop.athensRoute
        return allStops.filter { $0.id != locationSimulator.currentStop.id }
            .sorted { stop1, stop2 in
                distance(to: stop1) < distance(to: stop2)
            }
            .prefix(5)
            .map { $0 }
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

            ScrollView {
                VStack(spacing: 16) {
                    Text("Nearest Bus Stops")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top)

                    ForEach(nearbyStops) { stop in
                        BusStopCard(stop: stop, currentStop: locationSimulator.currentStop)
                    }

                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18))

                            Text("Back")
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
                    .padding(.top)
                    .padding(.bottom, 20)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Bus Stops")
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
            HelpView(content: HelpContentProvider.nearbyBusStops)
        }
    }

    private func distance(to stop: BusStop) -> Double {
        let current = CLLocation(
            latitude: locationSimulator.currentStop.coordinate.latitude,
            longitude: locationSimulator.currentStop.coordinate.longitude
        )
        let target = CLLocation(
            latitude: stop.coordinate.latitude,
            longitude: stop.coordinate.longitude
        )
        return target.distance(from: current) / 1000.0
    }
}

struct BusStopCard: View {
    let stop: BusStop
    let currentStop: BusStop

    private var distance: Double {
        let current = CLLocation(
            latitude: currentStop.coordinate.latitude,
            longitude: currentStop.coordinate.longitude
        )
        let target = CLLocation(
            latitude: stop.coordinate.latitude,
            longitude: stop.coordinate.longitude
        )
        return target.distance(from: current) / 1000.0
    }

    private var walkingMinutes: Int {
        Int((distance * 1000) / 80)
    }

    var body: some View {
        HStack {
            Image(systemName: "bus.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 50)

            VStack(alignment: .leading, spacing: 6) {
                Text(stop.name)
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    Label(String(format: "%.2f km", distance), systemImage: "mappin.circle.fill")
                        .font(.caption)

                    Label("\(walkingMinutes) min walk", systemImage: "figure.walk")
                        .font(.caption)
                }
                .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
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
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}

#Preview {
    NavigationStack {
        TouristNavigationView(destination: Landmark.athensLandmarks[0])
            .environmentObject(LocationSimulator())
    }
}
