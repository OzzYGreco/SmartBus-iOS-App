import SwiftUI

struct CoffeeMenuView: View {
    let place: CoffeePlace
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @State private var searchText = ""
    @State private var selectedQuantities: [UUID: Int] = [:]
    @State private var showingCart = false
    @State private var showingHelp = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dismissToRoot) private var dismissToRoot

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
                    Spacer()


                    Text("\(place.name) Menu")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    //Cart button with badge
                    ZStack(alignment: .topTrailing) {
                        Button(action: {
                            showingCart = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.25))
                                    .frame(width: 40, height: 40)

                                Image(systemName: "bag.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                        }

                        if cartManager.totalItems > 0 {
                            Text("\(cartManager.totalItems)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .frame(minWidth: 18, minHeight: 18)
                                .background(Circle().fill(Color.red))
                                .offset(x: 6, y: -2)
                        }
                    }
                    .padding(.trailing, 4)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)

                HStack(spacing: 12) {
                    Text("Add to cart")
                        .font(.largeTitle)
                        .foregroundColor(.white)

                    Spacer()

                    //Search bar
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))

                        TextField("Search", text: $searchText)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                    )
                    .frame(width: 140)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 16)

                //Menu items
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(filteredItems) { item in
                            MenuItemCard(
                                item: item,
                                placeName: place.name,
                                quantity: selectedQuantities[item.id] ?? 1,
                                onQuantityChange: { newQuantity in
                                    selectedQuantities[item.id] = newQuantity
                                },
                                onAddToCart: {
                                    let quantity = selectedQuantities[item.id] ?? 1
                                    cartManager.addItem(item, placeName: place.name, quantity: quantity)
                                }
                            )
                        }

                        //Home & Help buttons at bottom inside ScrollView
                        HStack(spacing: 16) {
                            Button(action: {
                                showingHelp = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "questionmark.circle.fill")
                                        .font(.system(size: 20))
                                    Text("Help")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 14)
                                .background(
                                    Capsule()
                                        .fill(Color.gray.opacity(0.7))
                                )
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            }

                            Button(action: {
                                navigationCoordinator.dismissToRoot()
                            }) {
                                Text("Home")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 14)
                                    .background(
                                        Capsule()
                                            .fill(Color.blue)
                                    )
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCart) {
            CartView()
        }
        .sheet(isPresented: $showingHelp) {
            HelpView(content: HelpContentProvider.coffeeMenu)
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

    var filteredItems: [MenuItem] {
        if searchText.isEmpty {
            return place.menuItems
        } else {
            return place.menuItems.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct MenuItemCard: View {
    let item: MenuItem
    let placeName: String
    let quantity: Int
    let onQuantityChange: (Int) -> Void
    let onAddToCart: () -> Void

    @State private var justAdded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            //Item name and price
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)

                    Text(item.description)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }

                Spacer()

                Text(item.formattedPrice)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }

            //Quantity and Add to cart button
            HStack {
                Spacer()

                //Quantity menu
                Menu {
                    ForEach(1...10, id: \.self) { num in
                        Button(action: {
                            onQuantityChange(num)
                        }) {
                            HStack {
                                Text("\(num)")
                                if num == quantity {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text("Qty \(quantity)")
                            .font(.system(size: 15, weight: .medium))
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.blue)
                }

                //Add to cart button
                Button(action: {
                    onAddToCart()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        justAdded = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            justAdded = false
                        }
                    }
                }) {
                    HStack(spacing: 6) {
                        if justAdded {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .transition(.scale.combined(with: .opacity))
                        }
                        Text(justAdded ? "Added!" : "Add to cart")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(justAdded ? Color.green : Color.blue)
                    )
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: justAdded)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.85))
        )
    }
}

#Preview {
    NavigationStack {
        CoffeeMenuView(
            place: CoffeePlace.samplePlaces[0]
        )
        .environmentObject(CartManager())
        .environmentObject(NavigationCoordinator())
    }
}
