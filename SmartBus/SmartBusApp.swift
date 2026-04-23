import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var popToRoot: Bool = false

    func dismissToRoot() {
        popToRoot = true
    }

    func reset() {
        popToRoot = false
    }
}

@main
struct SmartBusApp: App {
    @StateObject private var cartManager = CartManager()
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    @StateObject private var locationSimulator = LocationSimulator()
    @StateObject private var landmarkManager = LandmarkManager()
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var energyManager: EnergyManager
    @StateObject private var authManager = AuthManager()
    @State private var navigationPath = NavigationPath()
    @State private var showOnboarding = true

    init() {
        let weatherMgr = WeatherManager()
        _weatherManager = StateObject(wrappedValue: weatherMgr)
        _energyManager = StateObject(wrappedValue: EnergyManager(weatherManager: weatherMgr))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                HomeView()
            }
            .environmentObject(cartManager)
            .environmentObject(navigationCoordinator)
            .environmentObject(locationSimulator)
            .environmentObject(landmarkManager)
            .environmentObject(weatherManager)
            .environmentObject(energyManager)
            .environmentObject(authManager)
            .environment(\.dismissToRoot) {
                navigationPath = NavigationPath()
            }
            .sheet(isPresented: $showOnboarding) {
                HelpView(content: HelpContentProvider.home)
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    }
            }
            .onAppear {
                
                // Check if onboarding should be shown
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
                        showOnboarding = true
                    }
                }
            }
        }
    }
}
