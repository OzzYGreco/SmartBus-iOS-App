import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    @Published var currentRole: UserRole = .passenger
    @Published var isAuthenticated: Bool = false

    // Fixed credentials for UI/UX demo
    private let driverCredentials = (username: "driver", password: "driver123")
    private let employeeCredentials = (username: "employee", password: "employee123")

    func login(username: String, password: String) -> Bool {
        if username == driverCredentials.username && password == driverCredentials.password {
            currentRole = .driver
            isAuthenticated = true
            return true
        } else if username == employeeCredentials.username && password == employeeCredentials.password {
            currentRole = .employee
            isAuthenticated = true
            return true
        }
        return false
    }

    func logout() {
        currentRole = .passenger
        isAuthenticated = false
    }

    func canAccess(_ feature: AppFeature) -> Bool {
        return currentRole.availableFeatures.contains(feature)
    }
}
