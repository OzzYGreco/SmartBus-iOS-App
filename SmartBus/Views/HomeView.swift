import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showingHelp = false
    @State private var showingLogin = false

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

            ScrollView {
                VStack(spacing: 30) {
                    // Role indicator and auth buttons
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current Mode")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))

                            HStack(spacing: 6) {
                                Image(systemName: authManager.currentRole.icon)
                                Text(authManager.currentRole.displayName)
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        }

                        Spacer()

                        if authManager.isAuthenticated {
                            Button(action: { authManager.logout() }) {
                                Text("Logout")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.red.opacity(0.7))
                                    )
                            }
                        } else {
                            Button(action: { showingLogin = true }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "person.crop.circle.badge.checkmark")
                                    Text("Staff Login")
                                }
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    Text("Athens Bus App")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white,
                                Color.white.opacity(0.95)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.top, 40)

                VStack(spacing: 12) {
                    Text("Welcome to the Smart Bus!")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Please select any service you would like to use, and we will assist you! Enjoy the ride!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 25)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 8)

                Spacer()
                    .frame(height: 40)

                VStack(spacing: 25) {
                    // Row 1: Passenger features
                    if authManager.canAccess(.coffeeOrder) || authManager.canAccess(.vacuum) {
                        HStack(spacing: 25) {
                            if authManager.canAccess(.coffeeOrder) {
                                GlassmorphicButton(
                                    title: "Order Coffee",
                                    icon: "cup.and.saucer.fill",
                                    destination: CoffeeOrderView()
                                )
                            }

                            if authManager.canAccess(.vacuum) {
                                GlassmorphicButton(
                                    title: "Vacuum",
                                    icon: "wind",
                                    destination: VacuumServiceView()
                                )
                            }
                        }
                    }

                    // Row 2: Passenger features
                    if authManager.canAccess(.driverView) || authManager.canAccess(.landmarks) {
                        HStack(spacing: 25) {
                            if authManager.canAccess(.driverView) {
                                GlassmorphicButton(
                                    title: "Driver's View",
                                    icon: "car.fill",
                                    destination: DriverViewStreamView()
                                )
                            }

                            if authManager.canAccess(.landmarks) {
                                GlassmorphicButton(
                                    title: "Landmarks",
                                    icon: "building.columns.fill",
                                    destination: LandmarksView()
                                )
                            }
                        }
                    }

                    // Row 3: Driver features
                    if authManager.canAccess(.driverAssist) || authManager.canAccess(.climate) {
                        HStack(spacing: 25) {
                            if authManager.canAccess(.driverAssist) {
                                GlassmorphicButton(
                                    title: "Driver Assist",
                                    icon: "shield.checkered",
                                    destination: DriverDashboardView()
                                )
                            }

                            if authManager.canAccess(.climate) {
                                GlassmorphicButton(
                                    title: "Climate",
                                    icon: "thermometer.medium",
                                    destination: ClimateControlView()
                                )
                            }
                        }
                    }

                    // Row 4: Employee features
                    if authManager.canAccess(.roofControl) || authManager.canAccess(.energy) {
                        HStack(spacing: 25) {
                            if authManager.canAccess(.roofControl) {
                                GlassmorphicButton(
                                    title: "Roof Control",
                                    icon: "rectangle.on.rectangle",
                                    destination: RoofControlView()
                                )
                            }

                            if authManager.canAccess(.energy) {
                                GlassmorphicButton(
                                    title: "Energy",
                                    icon: "bolt.batteryblock",
                                    destination: EnergyDashboardView()
                                )
                            }
                        }
                    }
                }

                Button(action: {
                    showingHelp = true
                }) {
                    HStack(spacing: 12) {
                        Text("Need Help?")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))

                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                )
                                .frame(width: 36, height: 36)

                            Image(systemName: "questionmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingHelp) {
            HelpView(content: HelpContentProvider.home)
        }
        .sheet(isPresented: $showingLogin) {
            LoginView()
                .environmentObject(authManager)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(CartManager())
    .environmentObject(NavigationCoordinator())
    .environmentObject(AuthManager())
}
