import Foundation
import SwiftUI

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double

    var formattedPrice: String {
        String(format: "€%.2f ea", price)
    }
}

struct CartItem: Identifiable {
    let id: UUID
    let menuItem: MenuItem
    var quantity: Int
    let placeName: String

    init(id: UUID = UUID(), menuItem: MenuItem, quantity: Int, placeName: String) {
        self.id = id
        self.menuItem = menuItem
        self.quantity = quantity
        self.placeName = placeName
    }

    var totalPrice: Double {
        menuItem.price * Double(quantity)
    }
}