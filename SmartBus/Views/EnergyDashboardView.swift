import SwiftUI
import Charts

struct EnergyDashboardView: View {
    @EnvironmentObject var energyManager: EnergyManager
    @State private var showingHelp = false
    @State private var selectedTimeRange: TimeRange = .last30
    @Environment(\.dismiss) private var dismiss

    enum TimeRange: String, CaseIterable {
        case last10 = "10 min"
        case last30 = "30 min"
        case last60 = "1 hour"

        var dataPoints: Int {
            switch self {
            case .last10: return 20
            case .last30: return 60
            case .last60: return 100
            }
        }
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.4),
                    Color(red: 0.2, green: 0.1, blue: 0.3),
                    Color(red: 0.1, green: 0.2, blue: 0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Energy Dashboard")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Comprehensive Energy Monitoring")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top)

                    // Quick stats
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        QuickStatCard(
                            icon: "sun.max.fill",
                            title: "Solar",
                            value: String(format: "%.1f kW", energyManager.photovoltaicPanel.currentOutput),
                            color: .yellow
                        )

                        QuickStatCard(
                            icon: "bolt.fill",
                            title: "Consumption",
                            value: String(format: "%.1f kW", energyManager.totalConsumption),
                            color: .orange
                        )

                        QuickStatCard(
                            icon: "minus.plus.batteryblock",
                            title: "Net",
                            value: String(format: "%+.1f kW", energyManager.netEnergy),
                            color: energyManager.isSolarSurplus ? .green : .red
                        )
                    }
                    .padding(.horizontal)

                    // Battery status
                    VStack(spacing: 16) {
                        HStack {
                            Text("Battery Status")
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            HStack(spacing: 6) {
                                Circle()
                                    .fill(batteryHealthColor)
                                    .frame(width: 8, height: 8)

                                Text(energyManager.batteryState.health)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }

                        HStack(spacing: 20) {
                            // Battery visual
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                    .frame(width: 100, height: 50)

                                RoundedRectangle(cornerRadius: 6)
                                    .fill(
                                        LinearGradient(
                                            colors: batteryGradient,
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 94 * CGFloat(energyManager.batteryState.chargeLevel / 100), height: 44)
                                    .padding(3)

                                // Battery terminal
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white.opacity(0.5))
                                    .frame(width: 6, height: 20)
                                    .offset(x: 103)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(String(format: "%.0f%%", energyManager.batteryState.chargeLevel))")
                                        .font(.title2)
                                        .fontWeight(.bold)

                                    if energyManager.batteryState.isCharging {
                                        Image(systemName: "bolt.fill")
                                            .foregroundColor(.green)
                                    } else if energyManager.batteryState.isDischarging {
                                        Image(systemName: "bolt.slash.fill")
                                            .foregroundColor(.orange)
                                    }
                                }
                                .foregroundColor(.white)

                                Text("\(String(format: "%.1f kWh", energyManager.batteryState.remainingEnergy)) / \(String(format: "%.0f kWh", energyManager.batteryState.capacity))")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                Text("Est. range: \(String(format: "%.1f hours", energyManager.batteryState.estimatedRangeHours))")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            Spacer()
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

                    // Energy flow chart
                    VStack(spacing: 16) {
                        HStack {
                            Text("Energy History")
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            Picker("", selection: $selectedTimeRange) {
                                ForEach(TimeRange.allCases, id: \.self) { range in
                                    Text(range.rawValue).tag(range)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 200)
                        }

                        if energyManager.energyHistory.count >= 2 {
                            Chart {
                                ForEach(Array(energyManager.energyHistory.suffix(selectedTimeRange.dataPoints).enumerated()), id: \.offset) { index, data in
                                    LineMark(
                                        x: .value("Time", index),
                                        y: .value("Solar", data.solarGeneration)
                                    )
                                    .foregroundStyle(Color.yellow)
                                    .symbol(Circle())

                                    LineMark(
                                        x: .value("Time", index),
                                        y: .value("Consumption", data.totalConsumption)
                                    )
                                    .foregroundStyle(Color.red)
                                    .symbol(Circle())
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: .automatic) { _ in
                                    AxisValueLabel()
                                        .foregroundStyle(Color.white.opacity(0.7))
                                }
                            }
                            .chartYAxis {
                                AxisMarks { _ in
                                    AxisValueLabel()
                                        .foregroundStyle(Color.white.opacity(0.7))
                                    AxisGridLine()
                                        .foregroundStyle(Color.white.opacity(0.1))
                                }
                            }
                            .frame(height: 200)
                            .padding(.top, 8)

                            HStack(spacing: 20) {
                                Label("Solar Generation", systemImage: "circle.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)

                                Label("Consumption", systemImage: "circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        } else {
                            Text("Collecting data...")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .frame(height: 200)
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

                    // System consumption breakdown
                    VStack(spacing: 16) {
                        Text("System Consumption Breakdown")
                            .font(.headline)
                            .foregroundColor(.white)

                        VStack(spacing: 12) {
                            ForEach(energyManager.systemConsumptions, id: \.system.rawValue) { system in
                                SystemConsumptionRow(system: system)
                            }
                        }

                        HStack {
                            Text("Total Consumption")
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            Text(String(format: "%.2f kW", energyManager.totalConsumption))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 8)
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

                    // Efficiency metrics
                    VStack(spacing: 16) {
                        Text("Efficiency Metrics")
                            .font(.headline)
                            .foregroundColor(.white)

                        HStack(spacing: 12) {
                            EfficiencyCard(
                                title: "Solar Efficiency",
                                value: String(format: "%.0f%%", energyManager.photovoltaicPanel.efficiency),
                                icon: "sun.max.fill",
                                color: .yellow
                            )

                            EfficiencyCard(
                                title: "Battery Health",
                                value: energyManager.batteryState.health,
                                icon: "battery.100",
                                color: batteryHealthColor
                            )
                        }

                        HStack(spacing: 12) {
                            EfficiencyCard(
                                title: "Energy Generated",
                                value: String(format: "%.1f kWh", energyManager.photovoltaicPanel.totalEnergyGenerated),
                                icon: "bolt.fill",
                                color: .green
                            )

                            EfficiencyCard(
                                title: "Self-Sufficiency",
                                value: String(format: "%.0f%%", selfSufficiencyPercentage),
                                icon: "leaf.fill",
                                color: .green
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
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Energy Dashboard")
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
            HelpView(content: HelpContentProvider.energyDashboard)
        }
    }

    private var batteryHealthColor: Color {
        switch energyManager.batteryState.healthColor {
        case "green": return .green
        case "yellow": return .yellow
        case "orange": return .orange
        case "red": return .red
        default: return .gray
        }
    }

    private var batteryGradient: [Color] {
        let level = energyManager.batteryState.chargeLevel
        if level > 70 {
            return [.green, .green.opacity(0.7)]
        } else if level > 40 {
            return [.yellow, .yellow.opacity(0.7)]
        } else if level > 20 {
            return [.orange, .orange.opacity(0.7)]
        } else {
            return [.red, .red.opacity(0.7)]
        }
    }

    private var selfSufficiencyPercentage: Double {
        guard energyManager.totalConsumption > 0 else { return 0 }
        return min(100, (energyManager.photovoltaicPanel.currentOutput / energyManager.totalConsumption) * 100)
    }
}

struct QuickStatCard: View {
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
                .font(.subheadline)
                .fontWeight(.bold)
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

struct SystemConsumptionRow: View {
    let system: SystemConsumption

    private var systemColor: Color {
        switch system.system.color {
        case "blue": return .blue
        case "orange": return .orange
        case "yellow": return .yellow
        case "purple": return .purple
        case "green": return .green
        default: return .gray
        }
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Image(systemName: system.system.icon)
                    .foregroundColor(systemColor)
                    .frame(width: 24)

                Text(system.system.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.white)

                Spacer()

                Text(String(format: "%.2f kW", system.consumption))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("(\(String(format: "%.0f%%", system.percentage)))")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))

                    RoundedRectangle(cornerRadius: 4)
                        .fill(systemColor)
                        .frame(width: geometry.size.width * CGFloat(system.percentage / 100))
                }
            }
            .frame(height: 8)
        }
    }
}

struct EfficiencyCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        EnergyDashboardView()
            .environmentObject(EnergyManager())
    }
}
