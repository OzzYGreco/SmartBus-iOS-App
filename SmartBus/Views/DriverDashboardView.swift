import SwiftUI

struct DriverDashboardView: View {
    @StateObject private var safetyManager = SafetyManager()
    @EnvironmentObject var locationSimulator: LocationSimulator
    @State private var showingHelp = false
    @State private var showingAlertHistory = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.3, blue: 0.5),
                    Color(red: 0.3, green: 0.2, blue: 0.4),
                    Color(red: 0.2, green: 0.3, blue: 0.5)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Driver Assistance")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Safety monitoring and alerts")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top)

                    // Active alerts section
                    if !safetyManager.activeAlerts.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Active Alerts (\(safetyManager.activeAlerts.count))")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            ForEach(safetyManager.activeAlerts.sorted(by: { $0.priority > $1.priority }), id: \.rawValue) { alert in
                                SafetyAlertView(alert: alert) {
                                    withAnimation {
                                        safetyManager.dismissAlert(alert)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // Speed monitoring
                    VStack(spacing: 16) {
                        HStack {
                            Text("Speed Monitoring")
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            if safetyManager.currentMetrics.isSpeedingExcess {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)

                                    Text("Speeding")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.red)
                                }
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)

                                    Text("OK")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                }
                            }
                        }

                        HStack(spacing: 30) {
                            VStack(spacing: 8) {
                                Text(String(format: "%.0f", safetyManager.currentMetrics.currentSpeed))
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(safetyManager.currentMetrics.isSpeedingExcess ? .red : .white)

                                Text("Current Speed")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            Divider()
                                .background(Color.white.opacity(0.3))
                                .frame(height: 60)

                            VStack(spacing: 8) {
                                Text(String(format: "%.0f", safetyManager.currentMetrics.speedLimit))
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.white)

                                Text("Speed Limit")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }

                        // Speed bar indicator
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.2))

                                // Speed limit marker
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green.opacity(0.3))
                                    .frame(width: geometry.size.width * CGFloat(safetyManager.currentMetrics.speedLimit / 80.0))

                                // Current speed
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            colors: safetyManager.currentMetrics.isSpeedingExcess ?
                                            [Color.red, Color.orange] :
                                            [Color.blue, Color.cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * CGFloat(min(safetyManager.currentMetrics.currentSpeed / 80.0, 1.0)))
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

                    // Lane position monitoring
                    VStack(spacing: 16) {
                        HStack {
                            Text("Lane Position")
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            if safetyManager.currentMetrics.isOutOfLane {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)

                                    Text("Off Center")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.orange)
                                }
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)

                                    Text("Centered")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                }
                            }
                        }

                        // Lane visualization
                        GeometryReader { geometry in
                            ZStack {
                                // Road
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.3))

                                // Lane markers
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.3))
                                        .frame(width: 2)

                                    Spacer()

                                    Rectangle()
                                        .fill(Color.yellow.opacity(0.6))
                                        .frame(width: 2)

                                    Spacer()

                                    Rectangle()
                                        .fill(Color.white.opacity(0.3))
                                        .frame(width: 2)
                                }

                                // Bus position
                                Circle()
                                    .fill(safetyManager.currentMetrics.isOutOfLane ? Color.orange : Color.blue)
                                    .frame(width: 40, height: 40)
                                    .position(
                                        x: geometry.size.width * CGFloat(safetyManager.currentMetrics.lanePosition),
                                        y: geometry.size.height / 2
                                    )
                                    .shadow(color: .black.opacity(0.3), radius: 5)
                            }
                        }
                        .frame(height: 80)
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

                    // Fatigue monitoring
                    VStack(spacing: 16) {
                        HStack {
                            Text("Driver Fatigue")
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            if safetyManager.currentMetrics.isFatigued {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.yellow)

                                    Text("Tired")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.yellow)
                                }
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)

                                    Text("Alert")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.green)
                                }
                            }
                        }

                        HStack(spacing: 20) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 8)
                                        .frame(width: 80, height: 80)

                                    Circle()
                                        .trim(from: 0, to: CGFloat(safetyManager.currentMetrics.fatigueLevel))
                                        .stroke(
                                            fatigueColor,
                                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                        )
                                        .frame(width: 80, height: 80)
                                        .rotationEffect(.degrees(-90))

                                    Text(String(format: "%.0f%%", safetyManager.currentMetrics.fatigueLevel * 100))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }

                                Text("Fatigue Level")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Label(
                                    "\(safetyManager.currentMetrics.drivingDurationMinutes) minutes driving",
                                    systemImage: "clock.fill"
                                )
                                .font(.caption)

                                Label(
                                    "Next break recommended in \(max(0, 60 - safetyManager.currentMetrics.drivingDurationMinutes)) min",
                                    systemImage: "cup.and.saucer.fill"
                                )
                                .font(.caption)
                            }
                            .foregroundColor(.white.opacity(0.8))
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

                    // Route information
                    VStack(spacing: 12) {
                        Text("Current Route")
                            .font(.headline)
                            .foregroundColor(.white)

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current Stop")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                Text(locationSimulator.currentStop.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            Image(systemName: "arrow.right")
                                .foregroundColor(.white.opacity(0.5))

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Next Stop")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                Text(locationSimulator.nextStop.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
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

                    // Alert history button
                    Button(action: {
                        showingAlertHistory = true
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.title3)

                            Text("View Alert History (\(safetyManager.alertHistory.count))")
                                .font(.headline)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
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
                Text("Driver Dashboard")
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
            HelpView(content: HelpContentProvider.driverDashboard)
        }
        .sheet(isPresented: $showingAlertHistory) {
            AlertHistoryView(history: safetyManager.alertHistory)
        }
    }

    private var fatigueColor: Color {
        let level = safetyManager.currentMetrics.fatigueLevel
        if level < 0.3 {
            return .green
        } else if level < 0.7 {
            return .yellow
        } else {
            return .red
        }
    }
}

struct AlertHistoryView: View {
    let history: [(date: Date, alert: SafetyAlertType)]
    @Environment(\.dismiss) private var dismiss

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.4, green: 0.6, blue: 1.0),
                        Color(red: 0.6, green: 0.4, blue: 0.9)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(history.reversed().enumerated()), id: \.offset) { _, item in
                            HStack(spacing: 12) {
                                Image(systemName: item.alert.icon)
                                    .font(.title3)
                                    .foregroundColor(alertColor(for: item.alert))
                                    .frame(width: 40)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.alert.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)

                                    Text(dateFormatter.string(from: item.date))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }

                                Spacer()
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
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Alert History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }

    private func alertColor(for alert: SafetyAlertType) -> Color {
        switch alert.color {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "blue": return .blue
        default: return .gray
        }
    }
}

#Preview {
    NavigationStack {
        DriverDashboardView()
            .environmentObject(LocationSimulator())
    }
}
