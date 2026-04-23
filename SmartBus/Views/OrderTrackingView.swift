import SwiftUI

struct OrderTrackingView: View {
    @State private var order: Order
    @State private var timer: Timer?
    @State private var pulseAnimation = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator

    init(order: Order) {
        _order = State(initialValue: order)
    }

    var body: some View {
        ZStack {
            // Gradient background
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
                // Custom Navigation Bar
                HStack {
                    // Back button
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

                    // Title
                    Text("Track Order")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)

                // Main content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Current Status Highlight Card
                        CurrentStatusCard(order: order, pulseAnimation: $pulseAnimation)
                            .padding(.top, 16)

                        // Status Timeline
                        StatusTimelineView(order: order)

                        // Order Details Card
                        OrderDetailsCard(order: order)

                        // Estimated Time Card
                        EstimatedTimeCard(order: order)

                        // Action Buttons
                        VStack(spacing: 12) {
                            Button(action: {
                                navigationCoordinator.dismissToRoot()
                            }) {
                                Text("Back to Home")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white.opacity(0.2))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.white, lineWidth: 2)
                                            )
                                    )
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startSimulation()
            startPulseAnimation()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            if order.currentStatusIndex < OrderStatus.allCases.count - 1 {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    order.status = OrderStatus.allCases[order.currentStatusIndex + 1]
                }
            }
        }
    }

    private func startPulseAnimation() {
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
        ) {
            pulseAnimation = true
        }
    }
}

// MARK: - Current Status Card
struct CurrentStatusCard: View {
    let order: Order
    @Binding var pulseAnimation: Bool

    var body: some View {
        VStack(spacing: 16) {
            // Status Icon with pulse
            ZStack {
                // Pulse ring
                Circle()
                    .stroke(order.status.color.opacity(0.3), lineWidth: 3)
                    .frame(width: 100, height: 100)
                    .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                    .opacity(pulseAnimation ? 0 : 1)

                // Main circle
                Circle()
                    .fill(order.status.color)
                    .frame(width: 80, height: 80)
                    .shadow(color: order.status.color.opacity(0.5), radius: 10, x: 0, y: 5)

                Image(systemName: order.status.icon)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(spacing: 8) {
                Text(order.status.rawValue)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(order.status.description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Text(order.timeRemaining + " remaining")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(order.status.color)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                    )
                    .padding(.top, 4)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.15))
        )
    }
}

// MARK: - Status Timeline
struct StatusTimelineView: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Progress")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                ForEach(Array(order.statusTimeline.enumerated()), id: \.element) { index, status in
                    HStack(spacing: 16) {
                        // Icon
                        ZStack {
                            Circle()
                                .fill(isCompleted(index) ? status.color : Color.white.opacity(0.3))
                                .frame(width: 50, height: 50)

                            Image(systemName: status.icon)
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(isCurrent(index) ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: order.status)

                        // Status text
                        VStack(alignment: .leading, spacing: 4) {
                            Text(status.rawValue)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)

                            if isCurrent(index) {
                                Text("In Progress")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            } else if isCompleted(index) {
                                Text("Completed ✓")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            } else {
                                Text("Pending")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)

                    // Connector line
                    if index < order.statusTimeline.count - 1 {
                        Rectangle()
                            .fill(isCompleted(index) ? status.color : Color.white.opacity(0.3))
                            .frame(width: 3, height: 30)
                            .padding(.leading, 43)
                    }
                }
            }
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.15))
        )
    }

    private func isCompleted(_ index: Int) -> Bool {
        index < order.currentStatusIndex
    }

    private func isCurrent(_ index: Int) -> Bool {
        index == order.currentStatusIndex
    }
}

// MARK: - Order Details Card
struct OrderDetailsCard: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Details")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            // Order ID
            HStack {
                Text("Order ID")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Text(order.id)
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
            }

            Divider()
                .background(Color.white.opacity(0.3))

            // Items
            VStack(alignment: .leading, spacing: 8) {
                Text("Items")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))

                ForEach(order.items.prefix(3)) { item in
                    HStack {
                        Text("\(item.quantity)x")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 30, alignment: .leading)

                        Text(item.menuItem.name)
                            .font(.system(size: 15))
                            .foregroundColor(.white)

                        Spacer()

                        Text(String(format: "€%.2f", item.totalPrice))
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                    }
                }

                if order.items.count > 3 {
                    Text("+ \(order.items.count - 3) more items")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 4)
                }
            }

            Divider()
                .background(Color.white.opacity(0.3))

            // Payment Method
            HStack {
                Image(systemName: order.paymentMethod.icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 24)

                Text(order.paymentMethod.rawValue)
                    .font(.system(size: 15))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.green)
            }

            Divider()
                .background(Color.white.opacity(0.3))

            // Total
            HStack {
                Text("Total Paid")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Text(String(format: "€%.2f", order.totalPrice))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.15))
        )
    }
}

// MARK: - Estimated Time Card
struct EstimatedTimeCard: View {
    let order: Order

    var body: some View {
        HStack(spacing: 20) {
            // Clock icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 60, height: 60)

                Image(systemName: "clock.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.green)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Estimated Arrival")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))

                Text(order.estimatedDeliveryTime, style: .time)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(order.timeRemaining + " from now")
                    .font(.system(size: 13))
                    .foregroundColor(.green)
            }

            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.15))
        )
    }
}

#Preview {
    OrderTrackingView(order: Order(
        id: "SB123456",
        items: [],
        totalPrice: 12.50,
        paymentMethod: .applePay,
        status: .preparing,
        placedTime: Date(),
        estimatedDeliveryMinutes: 25
    ))
    .environmentObject(NavigationCoordinator())
}
