import SwiftUI

struct CoffeeOrderView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @Environment(\.dismiss) private var dismiss
    @State private var showingHelp = false
    let places = CoffeePlace.samplePlaces

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

                    Text("Coffee Places")
                        .frame(alignment: .center)

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
                    .padding(.trailing, 4)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                

                Text("Select a place")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 24)

                //Places list
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(places) { place in
                            NavigationLink(destination: CoffeeMenuView(place: place)) {
                                PlaceCardView(place: place)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                        //Home button at bottom inside ScrollView
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
                        .padding(.top, 32)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingHelp) {
            HelpView(content: HelpContentProvider.coffeeOrder)
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
}

struct PlaceCardView: View {
    let place: CoffeePlace

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(place.name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)

                HStack(spacing: 20) {
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 16))
                        Text("\(place.stops) stops")
                            .font(.system(size: 15))
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 16))
                        Text("\(place.minutes) minutes")
                            .font(.system(size: 15))
                    }
                }
                .foregroundColor(.black.opacity(0.7))
            }

            Spacer()

            Image(systemName: "checkmark")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.black.opacity(0.6))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.85))
        )
    }
}

#Preview {
    NavigationStack {
        CoffeeOrderView()
            .environmentObject(CartManager())
            .environmentObject(NavigationCoordinator())
    }
}

