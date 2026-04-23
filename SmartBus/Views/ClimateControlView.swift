import SwiftUI

struct ClimateControlView: View {
    @StateObject private var weatherManager = WeatherManager()
    @State private var showingHelp = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.3, green: 0.5, blue: 0.8),
                    Color(red: 0.4, green: 0.3, blue: 0.7),
                    Color(red: 0.3, green: 0.5, blue: 0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Climate Control")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Temperature & Environment Management")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top)

                    // Current weather
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: weatherManager.currentWeather.condition.icon)
                                .font(.largeTitle)
                                .foregroundColor(weatherColor)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(weatherManager.currentWeather.condition.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("Outdoor Conditions")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            Spacer()

                            Text(String(format: "%.0f°C", weatherManager.currentWeather.temperature))
                                .font(.system(size: 44, weight: .bold))
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 20) {
                            WeatherMetricView(
                                icon: "humidity.fill",
                                label: "Humidity",
                                value: "\(weatherManager.currentWeather.humidity)%"
                            )

                            WeatherMetricView(
                                icon: "wind",
                                label: "Wind",
                                value: String(format: "%.0f km/h", weatherManager.currentWeather.windSpeed)
                            )

                            WeatherMetricView(
                                icon: "thermometer.medium",
                                label: "Feels Like",
                                value: String(format: "%.0f°C", weatherManager.currentWeather.feelsLike)
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

                    // Current indoor temperature
                    VStack(spacing: 16) {
                        Text("Indoor Temperature")
                            .font(.headline)
                            .foregroundColor(.white)

                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 20)
                                .frame(width: 180, height: 180)

                            Circle()
                                .trim(from: 0, to: temperatureProgress)
                                .stroke(temperatureColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                .frame(width: 180, height: 180)
                                .rotationEffect(.degrees(-90))
                                .animation(.spring(), value: temperatureProgress)

                            VStack(spacing: 4) {
                                Text(String(format: "%.1f°C", weatherManager.climateSettings.currentTemperature))
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)

                                Text("Current")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
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

                    // Climate mode selector
                    VStack(spacing: 16) {
                        Text("Climate Mode")
                            .font(.headline)
                            .foregroundColor(.white)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(ClimateMode.allCases, id: \.self) { mode in
                                ClimateModeButton(
                                    mode: mode,
                                    isSelected: weatherManager.climateSettings.mode == mode,
                                    action: {
                                        withAnimation {
                                            weatherManager.setMode(mode)
                                        }
                                    }
                                )
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

                    // Temperature control
                    VStack(spacing: 16) {
                        HStack {
                            Text("Target Temperature")
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            Text(String(format: "%.0f°C", weatherManager.climateSettings.targetTemperature))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        HStack(spacing: 20) {
                            Button(action: {
                                weatherManager.setTargetTemperature(weatherManager.climateSettings.targetTemperature - 1)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.blue)
                            }

                            Slider(
                                value: Binding(
                                    get: { weatherManager.climateSettings.targetTemperature },
                                    set: { weatherManager.setTargetTemperature($0) }
                                ),
                                in: weatherManager.climateSettings.temperatureRange,
                                step: 0.5
                            )
                            .tint(temperatureColor)

                            Button(action: {
                                weatherManager.setTargetTemperature(weatherManager.climateSettings.targetTemperature + 1)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.red)
                            }
                        }

                        Text("Adjust target temperature (\(Int(weatherManager.climateSettings.temperatureRange.lowerBound))°C - \(Int(weatherManager.climateSettings.temperatureRange.upperBound))°C)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
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

                    // Fan speed control
                    VStack(spacing: 16) {
                        HStack {
                            Text("Fan Speed")
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()

                            Text(weatherManager.climateSettings.fanSpeed.label)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.9))
                        }

                        HStack(spacing: 12) {
                            ForEach(FanSpeed.allCases, id: \.self) { speed in
                                FanSpeedButton(
                                    speed: speed,
                                    isSelected: weatherManager.climateSettings.fanSpeed == speed,
                                    action: {
                                        withAnimation {
                                            weatherManager.setFanSpeed(speed)
                                        }
                                    }
                                )
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

                    // Recommendations
                    if weatherManager.climateSettings.mode != .auto {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)

                                Text("Recommendation")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }

                            Text("Based on current weather (\(String(format: "%.0f°C", weatherManager.currentWeather.temperature))), we recommend \(weatherManager.currentWeather.recommendedMode.rawValue) mode at \(String(format: "%.0f°C", weatherManager.currentWeather.recommendedTemperature)).")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))

                            Button(action: {
                                weatherManager.setMode(.auto)
                            }) {
                                Text("Apply Auto Settings")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        Capsule()
                                            .fill(Color.green.opacity(0.3))
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.green, lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.yellow.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal)
                    }

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
                Text("Climate Control")
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
            HelpView(content: HelpContentProvider.climateControl)
        }
    }

    private var weatherColor: Color {
        switch weatherManager.currentWeather.condition.color {
        case "yellow": return .yellow
        case "orange": return .orange
        case "gray": return .gray
        case "blue": return .blue
        case "purple": return .purple
        default: return .white
        }
    }

    private var temperatureColor: Color {
        let temp = weatherManager.climateSettings.currentTemperature
        if temp < 20 {
            return .blue
        } else if temp > 25 {
            return .red
        }
        return .green
    }

    private var temperatureProgress: CGFloat {
        let range = weatherManager.climateSettings.temperatureRange
        let normalized = (weatherManager.climateSettings.currentTemperature - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(min(max(normalized, 0), 1))
    }
}

struct WeatherMetricView: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)

            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))

            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ClimateModeButton: View {
    let mode: ClimateMode
    let isSelected: Bool
    let action: () -> Void

    private var modeColor: Color {
        switch mode.color {
        case "green": return .green
        case "blue": return .blue
        case "orange": return .orange
        case "gray": return .gray
        default: return .white
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mode.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? modeColor : .white.opacity(0.6))

                Text(mode.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ?
                          modeColor.opacity(0.3) :
                          Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? modeColor : Color.white.opacity(0.2), lineWidth: 2)
                    )
            )
        }
    }
}

struct FanSpeedButton: View {
    let speed: FanSpeed
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: speed.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .cyan : .white.opacity(0.6))

                Text(speed.label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ?
                          Color.cyan.opacity(0.3) :
                          Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.cyan : Color.white.opacity(0.2), lineWidth: 2)
                    )
            )
        }
    }
}

#Preview {
    NavigationStack {
        ClimateControlView()
    }
}
