import SwiftUI

struct VacuumSettingsView: View {
    let selectedSeats: Set<Int>
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var showingHelp = false
    @State private var cleaningMode: CleaningMode = .standard
    @State private var powerLevel: Double = 2
    @State private var includeDeepClean = false
    @State private var showingConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
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
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)

                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }

                        Spacer()

                        Text("Cleaning Settings")
                            .font(.system(size: 31, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()

                        Button(action: {
                            showingHelp = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 44, height: 44)

                                Image(systemName: "questionmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 24)

                    ScrollView {
                        VStack(spacing: 24) {
                            //Selected seats summary
                            VStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "chair.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.green)

                                    Text("Selected Seats")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)

                                    Spacer()

                                    Text("\(selectedSeats.count)")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.green)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(.white.opacity(0.2))
                                        )
                                }

                                let sortedSeats = selectedSeats.sorted()
                                Text("Seats: " + sortedSeats.map { String($0) }.joined(separator: ", "))
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )

                            //Cleaning mode
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Cleaning Mode")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                }

                                VStack(spacing: 12) {
                                    CleaningModeButton(
                                        mode: .quick,
                                        selectedMode: $cleaningMode,
                                        icon: "bolt.fill",
                                        title: "Quick Clean",
                                        description: "Fast surface cleaning (2-3 min/seat)",
                                        duration: "~\(selectedSeats.count * 2) min"
                                    )

                                    CleaningModeButton(
                                        mode: .standard,
                                        selectedMode: $cleaningMode,
                                        icon: "sparkles",
                                        title: "Standard Clean",
                                        description: "Thorough cleaning (5 min/seat)",
                                        duration: "~\(selectedSeats.count * 5) min"
                                    )

                                    CleaningModeButton(
                                        mode: .deep,
                                        selectedMode: $cleaningMode,
                                        icon: "diamond.fill",
                                        title: "Deep Clean",
                                        description: "Intensive deep cleaning (8 min/seat)",
                                        duration: "~\(selectedSeats.count * 8) min"
                                    )
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )

                            //Power level
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Suction Power")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(powerLevelText)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.green)
                                }

                                VStack(spacing: 8) {
                                    Slider(value: $powerLevel, in: 1...3, step: 1)
                                        .tint(.green)

                                    HStack {
                                        Text("Low")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Text("Medium")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Text("High")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )

                            //Additional options
                            VStack(spacing: 12) {
                                Toggle(isOn: $includeDeepClean) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "wand.and.stars")
                                            .font(.system(size: 20))
                                            .foregroundColor(.purple)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Include Sanitization")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)

                                            Text("Add antibacterial treatment")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                    }
                                }
                                .tint(.purple)
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )

                            //ETA
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Estimated Time")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.8))

                                    Text(estimatedTime)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.green)
                                }

                                Spacer()

                                Image(systemName: "clock.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.green.opacity(0.7))
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )

                            //Start button
                            Button(action: {
                                showingConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 20))

                                    Text("Start Cleaning")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.green)
                                )
                            }
                            .padding(.top, 16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }

                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showingConfirmation) {
                VacuumConfirmationView(
                    selectedSeats: selectedSeats,
                    cleaningMode: cleaningMode,
                    powerLevel: Int(powerLevel),
                    includeSanitization: includeDeepClean
                )
            }
            .onChange(of: navigationCoordinator.popToRoot) { _, newValue in
                if newValue {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingHelp) {
                HelpView(content: HelpContentProvider.vacuumSettings)
            }
        }
    }

    private var powerLevelText: String {
        switch Int(powerLevel) {
        case 1: return "Low"
        case 2: return "Medium"
        case 3: return "High"
        default: return "Medium"
        }
    }

    private var estimatedTime: String {
        let baseMinutes: Int
        switch cleaningMode {
        case .quick: baseMinutes = 2
        case .standard: baseMinutes = 5
        case .deep: baseMinutes = 8
        }

        let total = baseMinutes * selectedSeats.count + (includeDeepClean ? 2 * selectedSeats.count : 0)
        return "\(total) min"
    }
}

enum CleaningMode: String, CaseIterable {
    case quick = "Quick"
    case standard = "Standard"
    case deep = "Deep"
}

struct CleaningModeButton: View {
    let mode: CleaningMode
    @Binding var selectedMode: CleaningMode
    let icon: String
    let title: String
    let description: String
    let duration: String

    var isSelected: Bool {
        mode == selectedMode
    }

    var body: some View {
        Button(action: {
            selectedMode = mode
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.green.opacity(0.2) : Color.white.opacity(0.1))
                        .frame(width: 50, height: 50)

                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? .green : .white.opacity(0.7))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(duration)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isSelected ? .green : .white.opacity(0.8))

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.green.opacity(0.15) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.green : Color.white.opacity(0.2), lineWidth: 2)
                    )
            )
        }
    }
}

#Preview {
    VacuumSettingsView(selectedSeats: [1, 2, 5, 9])
        .environmentObject(NavigationCoordinator())
}
