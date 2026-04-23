import SwiftUI

struct VacuumServiceView: View {
    @State private var selectedSeats: Set<Int> = []
    @State private var showingSettings = false
    @State private var showingHelp = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator

    //Bus layout: 4 x 4 (2 on each side)
    let seatRows = [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 16]
    ]

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

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.25))
                                .frame(width: 40, height: 40)

                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.leading, 12)
                    
                    Spacer()

                    Text("Vacuum Service")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    Button(action: {
                        showingHelp = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.25))
                                .frame(width: 40, height: 40)

                            Image(systemName: "questionmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, 12)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)

                Text("Select areas to clean")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 16)

                //Legend (selection icons)
                HStack(spacing: 24) {
                    LegendItem(color: .white.opacity(0.3), text: "Available")
                    LegendItem(color: .green, text: "Selected")
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 20) {
                            HStack {
                                Spacer()
                                VStack(spacing: 8) {
                                    Image(systemName: "steeringwheel")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("Driver")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                Spacer()
                            }

                            //Seat map
                            VStack(spacing: 16) {
                                ForEach(seatRows, id: \.self) { row in
                                    HStack(spacing: 16) {
                                        //Left side seats
                                        SeatButton(
                                            seatNumber: row[0],
                                            isSelected: selectedSeats.contains(row[0]),
                                            action: { toggleSeat(row[0]) }
                                        )
                                        SeatButton(
                                            seatNumber: row[1],
                                            isSelected: selectedSeats.contains(row[1]),
                                            action: { toggleSeat(row[1]) }
                                        )

                                        //Aisle
                                        Spacer()
                                            .frame(width: 40)

                                        //Right side seats
                                        SeatButton(
                                            seatNumber: row[2],
                                            isSelected: selectedSeats.contains(row[2]),
                                            action: { toggleSeat(row[2]) }
                                        )
                                        SeatButton(
                                            seatNumber: row[3],
                                            isSelected: selectedSeats.contains(row[3]),
                                            action: { toggleSeat(row[3]) }
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 16)

                        //Selection summary
                        if !selectedSeats.isEmpty {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Selected Seats")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(selectedSeats.count)")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.green)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(.white.opacity(0.2))
                                        )
                                }

                                //Selected seat numbers
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
                            .padding(.horizontal, 16)
                        }

                        //Buttons section
                        VStack(spacing: 12) {
                            Button(action: {
                                showingSettings = true
                            }) {
                                Text("Continue")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(selectedSeats.isEmpty ? Color.gray.opacity(0.5) : Color.green)
                                    )
                            }
                            .disabled(selectedSeats.isEmpty)

                            Button(action: {
                                navigationCoordinator.dismissToRoot()
                            }) {
                                Text("Home")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16).fill(Color.blue)
                                    )
                            }
                        
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 32)
                        .padding(.bottom, 40)
                    }
                    .padding(.top, 16)
                }

            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingSettings) {
            VacuumSettingsView(selectedSeats: selectedSeats)
        }
        .sheet(isPresented: $showingHelp) {
            HelpView(content: HelpContentProvider.vacuumService)
        }
        .onChange(of: navigationCoordinator.popToRoot) { _, newValue in
            if newValue {
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    dismiss()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    navigationCoordinator.reset()
                }
            }
        }
    }

    private func toggleSeat(_ seatNumber: Int) {
        if selectedSeats.contains(seatNumber) {
            selectedSeats.remove(seatNumber)
        } else {
            selectedSeats.insert(seatNumber)
        }
    }
}

struct SeatButton: View {
    let seatNumber: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? "chair.fill" : "chair")
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .green : .white.opacity(0.7))

                Text("\(seatNumber)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.green.opacity(0.2) : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.green : Color.white.opacity(0.3), lineWidth: 2)
                    )
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

struct LegendItem: View {
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 20, height: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    NavigationStack {
        VacuumServiceView()
    }
    .environmentObject(NavigationCoordinator())
}
