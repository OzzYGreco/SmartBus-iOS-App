import SwiftUI

struct VacuumConfirmationView: View {
    let selectedSeats: Set<Int>
    let cleaningMode: CleaningMode
    let powerLevel: Int
    let includeSanitization: Bool

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var showCheckmark = false
    @State private var showingHelp = false
    @State private var showContent = false
    @State private var cleaningProgress: Double = 0.0
    @State private var currentStatus = "Initializing..."
    @State private var isCompleted = false
    @State private var foundItems: [LostItem] = []
    @State private var showingLostItemsAlert = false

    let serviceID: String

    init(selectedSeats: Set<Int>, cleaningMode: CleaningMode, powerLevel: Int, includeSanitization: Bool) {
        self.selectedSeats = selectedSeats
        self.cleaningMode = cleaningMode
        self.powerLevel = powerLevel
        self.includeSanitization = includeSanitization
        self.serviceID = "VAC" + String(format: "%06d", Int.random(in: 100000...999999))
    }

    var body: some View {
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

            VStack {
                HStack {
                    Spacer()
                    HelpButton(content: HelpContentProvider.vacuumConfirmation)
                        .padding(.top, 20)
                        .padding(.trailing, 24)
                }
                Spacer()
            }

            VStack(spacing: 0) {
                Spacer()

                if isCompleted {
                    VStack(spacing: 24) {
                        ZStack {
                            //Outer circle with animation
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                .frame(width: 140, height: 140)
                                .scaleEffect(showCheckmark ? 1.1 : 0.8)
                                .opacity(showCheckmark ? 0 : 1)

                            //Main circle
                            Circle()
                                .fill(Color.white)
                                .frame(width: 120, height: 120)
                                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)

                            //Checkmark
                            Image(systemName: "checkmark")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.green)
                                .scaleEffect(showCheckmark ? 1 : 0)
                        }

                        VStack(spacing: 8) {
                            Text("Cleaning Complete!")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)

                            Text("Your selected areas are now clean")
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.bottom, 40)
                } else {
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 120, height: 120)

                            Image(systemName: "wind")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                                .rotationEffect(.degrees(cleaningProgress * 360))
                        }
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)

                        VStack(spacing: 8) {
                            Text("Cleaning in Progress")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)

                            Text(currentStatus)
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.9))
                        }

                        //Progress bar
                        VStack(spacing: 12) {
                            ProgressView(value: cleaningProgress)
                                .tint(.green)
                                .scaleEffect(x: 1, y: 2, anchor: .center)

                            HStack {
                                Text("\(Int(cleaningProgress * 100))%")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.green)
                                Spacer()
                                Text("\(selectedSeats.count) seats")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 40)
                }

                //Service details card
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Service ID")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                            Text(serviceID)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 6) {
                            Text("Mode")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                            Text(cleaningMode.rawValue)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.green)
                        }
                    }

                    Divider()
                        .background(Color.white.opacity(0.3))

                    //Service details
                    VStack(spacing: 12) {
                        DetailRow(label: "Seats", value: "\(selectedSeats.count)")
                        DetailRow(label: "Power Level", value: powerLevelText)
                        if includeSanitization {
                            DetailRow(label: "Sanitization", value: "Included", valueColor: .purple)
                        }
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                Spacer()

                //Action button
                if isCompleted {
                    Button(action: {
                        if !foundItems.isEmpty && foundItems.contains(where: { !$0.isAlerted }) {
                            showingLostItemsAlert = true
                        } else {
                            navigationCoordinator.dismissToRoot()
                        }
                    }) {
                        Text("Done")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.green)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .opacity(showContent ? 1 : 0)
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingLostItemsAlert) {
            LostItemsAlertView(foundItems: $foundItems, onDismiss: {
                showingLostItemsAlert = false
            })
        }
        .onAppear {
            startCleaning()
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
    }

    private var powerLevelText: String {
        switch powerLevel {
        case 1: return "Low"
        case 2: return "Medium"
        case 3: return "High"
        default: return "Medium"
        }
    }

    private func startCleaning() {
        //Show content
        withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
            showContent = true
        }

        //Simulation of cleaning progress
        let totalDuration: Double = 5.0
        let steps = 50
        let interval = totalDuration / Double(steps)

        let statuses = [
            "Preparing vacuum system...",
            "Cleaning seat \(selectedSeats.sorted().first ?? 1)...",
            "Cleaning seat \(selectedSeats.sorted()[min(1, selectedSeats.count - 1)])...",
            "Deep cleaning in progress...",
            includeSanitization ? "Applying sanitization..." : "Final touches...",
            "Finalizing..."
        ]

        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                cleaningProgress = Double(i) / Double(steps)

                //Update status
                let statusIndex = Int(Double(statuses.count) * cleaningProgress)
                if statusIndex < statuses.count {
                    currentStatus = statuses[statusIndex]
                }

                //Complete when done
                if i == steps {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isCompleted = true

                        //Generate random lost items
                        let possibleItems = [
                            LostItem(itemName: "Phone Charger", seatNumber: selectedSeats.sorted()[0], description: "Black USB-C cable"),
                            LostItem(itemName: "Water Bottle", seatNumber: selectedSeats.sorted()[min(1, selectedSeats.count - 1)], description: "Blue stainless steel bottle"),
                            LostItem(itemName: "Earbuds", seatNumber: selectedSeats.sorted()[selectedSeats.count / 2], description: "White wireless earbuds in case")
                        ]

                        //Randomly select 0-3 items to be found
                        if Bool.random() {
                            let itemCount = Int.random(in: 1...min(3, possibleItems.count))
                            foundItems = Array(possibleItems.shuffled().prefix(itemCount))
                        }

                        //Animate checkmark
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                            showCheckmark = true
                        }

                        //Show lost items alert if any were found
                        if !foundItems.isEmpty {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                showingLostItemsAlert = true
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    var valueColor: Color = .white

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(valueColor)
        }
    }
}

#Preview {
    VacuumConfirmationView(
        selectedSeats: [1, 2, 5, 9],
        cleaningMode: .standard,
        powerLevel: 2,
        includeSanitization: true
    )
    .environmentObject(NavigationCoordinator())
}
