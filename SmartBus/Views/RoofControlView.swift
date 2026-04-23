import SwiftUI

struct RoofControlView: View {
    @EnvironmentObject var energyManager: EnergyManager
    @EnvironmentObject var weatherManager: WeatherManager
    @State private var showingHelp = false
    @State private var showWeatherWarning = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.6),
                    Color(red: 0.3, green: 0.3, blue: 0.5),
                    Color(red: 0.2, green: 0.4, blue: 0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Roof Management")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Photovoltaic Roof Control")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top)

                    // Current weather status
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: weatherManager.currentWeather.condition.icon)
                                .font(.title2)
                                .foregroundColor(weatherConditionColor)

                            Text(weatherManager.currentWeather.condition.rawValue)
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            Text(String(format: "%.0f°C", weatherManager.currentWeather.temperature))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        if weatherManager.currentWeather.condition.isRaining {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)

                                Text("Roof cannot be opened during rain")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.orange.opacity(0.2))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                                    )
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

                    // Roof status visualization
                    VStack(spacing: 16) {
                        Text("Roof Status")
                            .font(.headline)
                            .foregroundColor(.white)

                        // Animated roof visualization
                        GeometryReader { geometry in
                            ZStack {
                                // Bus body
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.6)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: geometry.size.width * 0.8, height: 100)

                                // Roof panels (split in middle)
                                HStack(spacing: 0) {
                                    // Left panel
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(
                                            width: (geometry.size.width * 0.4) - (energyManager.roofState.openPercentage * geometry.size.width * 0.2),
                                            height: 80
                                        )
                                        .offset(x: -energyManager.roofState.openPercentage * geometry.size.width * 0.1)

                                    Spacer()

                                    // Right panel
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(
                                            width: (geometry.size.width * 0.4) - (energyManager.roofState.openPercentage * geometry.size.width * 0.2),
                                            height: 80
                                        )
                                        .offset(x: energyManager.roofState.openPercentage * geometry.size.width * 0.1)
                                }
                                .frame(width: geometry.size.width * 0.8)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                        .frame(height: 150)

                        // Status label
                        HStack(spacing: 8) {
                            Image(systemName: energyManager.roofState.position.icon)
                                .font(.title3)

                            Text(energyManager.roofState.position.rawValue)
                                .font(.headline)

                            Text("(\(Int(energyManager.roofState.openPercentage * 100))%)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .foregroundColor(.white)

                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.2))

                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.cyan, Color.blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * CGFloat(energyManager.roofState.openPercentage))
                            }
                        }
                        .frame(height: 20)
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

                    // Control buttons
                    HStack(spacing: 20) {
                        // Open button
                        Button(action: {
                            if weatherManager.currentWeather.condition.isRaining {
                                showWeatherWarning = true
                            } else {
                                energyManager.openRoof()
                            }
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: "rectangle")
                                    .font(.system(size: 40))
                                    .foregroundColor(energyManager.roofState.canOpen ? .white : .white.opacity(0.3))

                                Text("Open Roof")
                                    .font(.headline)
                                    .foregroundColor(energyManager.roofState.canOpen ? .white : .white.opacity(0.3))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(energyManager.roofState.canOpen ?
                                          Color.green.opacity(0.3) :
                                          Color.gray.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(energyManager.roofState.canOpen ?
                                                  Color.green :
                                                  Color.gray.opacity(0.3), lineWidth: 2)
                                    )
                            )
                        }
                        .disabled(!energyManager.roofState.canOpen)

                        // Close button
                        Button(action: {
                            energyManager.closeRoof()
                        }) {
                            VStack(spacing: 12) {
                                Image(systemName: "rectangle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(energyManager.roofState.canClose ? .white : .white.opacity(0.3))

                                Text("Close Roof")
                                    .font(.headline)
                                    .foregroundColor(energyManager.roofState.canClose ? .white : .white.opacity(0.3))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(energyManager.roofState.canClose ?
                                          Color.blue.opacity(0.3) :
                                          Color.gray.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(energyManager.roofState.canClose ?
                                                  Color.blue :
                                                  Color.gray.opacity(0.3), lineWidth: 2)
                                    )
                            )
                        }
                        .disabled(!energyManager.roofState.canClose)
                    }
                    .padding(.horizontal)

                    // Photovoltaic performance
                    VStack(spacing: 16) {
                        Text("Solar Panel Performance")
                            .font(.headline)
                            .foregroundColor(.white)

                        HStack(spacing: 30) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 12)
                                        .frame(width: 100, height: 100)

                                    Circle()
                                        .trim(from: 0, to: CGFloat(energyManager.photovoltaicPanel.efficiency / 100))
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.yellow, Color.orange],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                        )
                                        .frame(width: 100, height: 100)
                                        .rotationEffect(.degrees(-90))

                                    Text(String(format: "%.0f%%", energyManager.photovoltaicPanel.efficiency))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }

                                Text("Efficiency")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.yellow)
                                    Text("Output: \(String(format: "%.2f kW", energyManager.photovoltaicPanel.currentOutput))")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }

                                HStack {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(.green)
                                    Text("Generated: \(String(format: "%.1f kWh", energyManager.photovoltaicPanel.totalEnergyGenerated))")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }

                                HStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(statusColor)
                                    Text("Status: \(energyManager.photovoltaicPanel.status)")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
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

                    // Link to energy dashboard
                    NavigationLink(destination: EnergyDashboardView()) {
                        HStack(spacing: 10) {
                            Image(systemName: "chart.xyaxis.line")
                                .font(.title3)

                            Text("View Energy Dashboard")
                                .font(.headline)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.purple.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.purple, lineWidth: 2)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)

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
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Roof Control")
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
            HelpView(content: HelpContentProvider.roofControl)
        }
        .alert("Weather Warning", isPresented: $showWeatherWarning) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Cannot open roof during rainy conditions for safety reasons.")
        }
    }

    private var weatherConditionColor: Color {
        switch weatherManager.currentWeather.condition {
        case .sunny: return .yellow
        case .partlyCloudy: return .orange
        case .cloudy: return .gray
        case .rainy, .stormy: return .blue
        }
    }

    private var statusColor: Color {
        switch energyManager.photovoltaicPanel.status {
        case "High": return .green
        case "Medium": return .yellow
        default: return .orange
        }
    }
}

#Preview {
    NavigationStack {
        RoofControlView()
            .environmentObject(EnergyManager())
            .environmentObject(WeatherManager())
    }
}
