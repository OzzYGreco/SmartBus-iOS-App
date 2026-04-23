import SwiftUI
import MapKit

struct DriverViewStreamView: View {
    @StateObject private var locationSimulator = LocationSimulator()
    @State private var selectedAngle: CameraAngle = .forward
    @State private var showingHelp = false
    @State private var imageIndex = 0
    @Environment(\.dismiss) private var dismiss

    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

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
                // Camera view simulation
                ZStack {
                    // Simulated driving view (placeholder with color and text)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.gray.opacity(0.3),
                                    Color.gray.opacity(0.5)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            VStack(spacing: 12) {
                                Image(systemName: "car.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.4))

                                Text("Athens - \(selectedAngle.rawValue)")
                                    .font(.title3)
                                    .foregroundColor(.white.opacity(0.6))

                                Text("🏛️ Driving through historic Athens 🏛️")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.horizontal)
                                    .multilineTextAlignment(.center)

                                // Animated road lines
                                HStack(spacing: 40) {
                                    ForEach(0..<3) { _ in
                                        Capsule()
                                            .fill(Color.yellow.opacity(0.3))
                                            .frame(width: 8, height: 60)
                                    }
                                }
                                .padding(.top, 20)
                            }
                        )
                        .frame(height: 350)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.3), radius: 10)

                    // Speed overlay (top-left)
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(String(format: "%.0f", locationSimulator.currentSpeed))
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)

                                Text("km/h")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.2), radius: 5)

                            Spacer()
                        }
                        .padding()

                        Spacer()
                    }

                    // Time and location overlay (top-right)
                    VStack {
                        HStack {
                            Spacer()

                            VStack(alignment: .trailing, spacing: 8) {
                                HStack(spacing: 6) {
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                    Text(currentTime)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }

                                HStack(spacing: 6) {
                                    Image(systemName: "location.fill")
                                        .font(.caption)
                                    Text("Athens, Greece")
                                        .font(.caption)
                                }

                                HStack(spacing: 6) {
                                    Image(systemName: "map.fill")
                                        .font(.caption)
                                    Text(locationSimulator.currentStop.name)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }
                            .foregroundColor(.white)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .black.opacity(0.2), radius: 5)
                        }
                        .padding()

                        Spacer()
                    }

                    // Next stop info (bottom overlay)
                    VStack {
                        Spacer()

                        HStack(spacing: 12) {
                            Image(systemName: "figure.walk")
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Next Stop")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))

                                Text(locationSimulator.nextStop.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(locationSimulator.minutesToStop(stopId: locationSimulator.nextStop.id)) min")
                                    .font(.title3)
                                    .fontWeight(.bold)

                                ProgressView(value: locationSimulator.progressToNextStop)
                                    .tint(.green)
                                    .frame(width: 60)
                            }
                        }
                        .foregroundColor(.white)
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
                        .padding(.bottom, 10)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                // Camera angle selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(CameraAngle.allCases, id: \.self) { angle in
                            Button(action: {
                                withAnimation {
                                    selectedAngle = angle
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: angle.icon)
                                        .font(.system(size: 16))

                                    Text(angle.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .foregroundColor(selectedAngle == angle ? .white : .white.opacity(0.7))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedAngle == angle ?
                                              Color.white.opacity(0.3) :
                                              Color.white.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)

                // Route progress info
                VStack(spacing: 16) {
                    HStack {
                        Text("Route Progress")
                            .font(.headline)
                            .foregroundColor(.white)

                        Spacer()

                        Text("\(locationSimulator.routeElapsedMinutes) / 90 min")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }

                    HStack(spacing: 20) {
                        VStack(spacing: 6) {
                            Text("Current Stop")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text(locationSimulator.currentStop.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)

                        Divider()
                            .background(Color.white.opacity(0.3))
                            .frame(height: 40)

                        VStack(spacing: 6) {
                            Text("Progress")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Text(String(format: "%.0f%%", locationSimulator.progressToNextStop * 100))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                        .frame(maxWidth: .infinity)
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

                Spacer()

                // Home button
                Button(action: {
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Driver's View")
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
            HelpView(content: HelpContentProvider.driverView)
        }
    }

    private var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

#Preview {
    NavigationStack {
        DriverViewStreamView()
    }
}
