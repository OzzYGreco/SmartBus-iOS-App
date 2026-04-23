import SwiftUI

struct OrderConfirmationView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss
    let paymentMethod: PaymentMethod
    let orderID: String
    let estimatedTime: String

    @State private var showCheckmark = false
    @State private var showContent = false
    @State private var showingTracking = false

    init(paymentMethod: PaymentMethod) {
        self.paymentMethod = paymentMethod
        self.orderID = "SB" + String(format: "%06d", Int.random(in: 100000...999999))

        //Calculate ETA (10-40 minutes based on random cafe)
        let minutes = Int.random(in: 10...40)
        self.estimatedTime = "\(minutes) min"
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

            VStack(spacing: 0) {
                Spacer()

                //Success animation
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
                        Text("Order Confirmed!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(showContent ? 1 : 0)

                        Text("Your order has been placed successfully")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.9))
                            .opacity(showContent ? 1 : 0)
                    }
                }
                .padding(.bottom, 40)

                //Order details card
                VStack(spacing: 0) {
                    //Order ID and Time
                    VStack(spacing: 20) {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Order ID")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Text(orderID)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 6) {
                                Text("Estimated Time")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                Text(estimatedTime)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.green)
                            }
                        }

                        Divider()

                        //Payment info
                        HStack {
                            Image(systemName: paymentMethod.icon)
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                                .frame(width: 32)

                            Text(paymentMethod.rawValue)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black)

                            Spacer()

                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                        }

                        Divider()

                        //Order summary
                        VStack(spacing: 12) {
                            HStack {
                                Text("Order Summary")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                            }

                            ForEach(cartManager.items.prefix(3)) { item in
                                HStack {
                                    Text("\(item.quantity)x")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                        .frame(width: 30, alignment: .leading)

                                    Text(item.menuItem.name)
                                        .font(.system(size: 15))
                                        .foregroundColor(.black)

                                    Spacer()

                                    Text(String(format: "€%.2f", item.totalPrice))
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)
                                }
                            }

                            if cartManager.items.count > 3 {
                                HStack {
                                    Text("+ \(cartManager.items.count - 3) more items")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                        }

                        Divider()

                        //Total
                        HStack {
                            Text("Total Paid")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                            Text(String(format: "€%.2f", cartManager.totalPrice))
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(24)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                Spacer()

                //Bottom buttons
                VStack(spacing: 12) {
                    Button(action: {
                        cartManager.clearCart()
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

                    Button(action: {
                        showingTracking = true
                    }) {
                        Text("Track Order")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingTracking) {
            OrderTrackingView(order: Order(
                id: orderID,
                items: Array(cartManager.items),
                totalPrice: cartManager.totalPrice,
                paymentMethod: paymentMethod,
                status: .placed,
                placedTime: Date(),
                estimatedDeliveryMinutes: Int(estimatedTime.replacingOccurrences(of: " min", with: "")) ?? 20
            ))
            .environmentObject(navigationCoordinator)
        }
        .onAppear {
            //Animated checkmark
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                showCheckmark = true
            }

            //Animated content
            withAnimation(.easeOut(duration: 0.4).delay(0.6)) {
                showContent = true
            }
        }
    }
}

#Preview {
    OrderConfirmationView(paymentMethod: .applePay)
        .environmentObject(CartManager())
        .environmentObject(NavigationCoordinator())
}
