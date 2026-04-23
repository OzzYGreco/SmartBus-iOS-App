import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingPayment = false
    @State private var showingHelp = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(width: 44, height: 44)

                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }

                    Spacer()

                    Text("My Cart")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)

                    Spacer()

                    Button(action: {
                        showingHelp = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(width: 44, height: 44)

                            Image(systemName: "questionmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 20)

                if cartManager.items.isEmpty {
                    //Empty cart state
                    VStack(spacing: 20) {
                        Spacer()

                        Image(systemName: "cart")
                            .font(.system(size: 80))
                            .foregroundColor(.gray.opacity(0.5))

                        Text("Your cart is empty")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)

                        Text("Add items from the menu to get started")
                            .font(.body)
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)

                        Spacer()
                    }
                    .padding()
                } else {
                    //Cart items
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(cartManager.items) { item in
                                CartItemRow(item: item)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 200)
                    }
                }

                Spacer()
            }

            //Bottom section with total and checkout button
            if !cartManager.items.isEmpty {
                VStack {
                    Spacer()

                    VStack(spacing: 16) {
                        //Total section
                        VStack(spacing: 12) {
                            HStack {
                                Text("Subtotal")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(String(format: "€%.2f", cartManager.totalPrice))
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                            }

                            Divider()

                            HStack {
                                Text("Total")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                Spacer()
                                Text(String(format: "€%.2f", cartManager.totalPrice))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.1))
                        )

                        //Checkout button
                        Button(action: {
                            showingPayment = true
                        }) {
                            Text("Proceed to Payment")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.blue)
                                )
                        }
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(20)
                    .background(
                        Color.white
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                    )
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingPayment) {
            PaymentSelectionView()
        }
        .sheet(isPresented: $showingHelp) {
            HelpView(content: HelpContentProvider.cart)
        }
    }
}

struct CartItemRow: View {
    @EnvironmentObject var cartManager: CartManager
    let item: CartItem

    var body: some View {
        HStack(spacing: 16) {
            //Item icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)

                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }

            //Item details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.menuItem.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)

                Text(item.placeName)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text(String(format: "€%.2f each", item.menuItem.price))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()

            //Quantity controls
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Button(action: {
                        if item.quantity > 1 {
                            cartManager.updateQuantity(for: item, quantity: item.quantity - 1)
                        } else {
                            cartManager.removeItem(item)
                        }
                    }) {
                        Image(systemName: item.quantity == 1 ? "trash.fill" : "minus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(item.quantity == 1 ? .red : .blue)
                    }

                    Text("\(item.quantity)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(minWidth: 20)

                    Button(action: {
                        cartManager.updateQuantity(for: item, quantity: item.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                    }
                }

                Text(String(format: "€%.2f", item.totalPrice))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.08))
        )
    }
}

#Preview {
    NavigationStack {
        CartView()
            .environmentObject(CartManager())
    }
}
