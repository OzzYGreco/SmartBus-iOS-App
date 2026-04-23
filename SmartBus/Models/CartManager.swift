import Foundation
import SwiftUI

class CartManager: ObservableObject {
    @Published var items: [CartItem] = []

    var totalItems: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }

    func addItem(_ menuItem: MenuItem, placeName: String, quantity: Int = 1) {
        if let index = items.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
            items[index] = CartItem(
                id: items[index].id,
                menuItem: menuItem,
                quantity: items[index].quantity + quantity,
                placeName: placeName
            )
        } else {
            let newItem = CartItem(
                menuItem: menuItem,
                quantity: quantity,
                placeName: placeName
            )
            items.append(newItem)
        }
    }

    func updateQuantity(for cartItem: CartItem, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == cartItem.id }) {
            if quantity <= 0 {
                items.remove(at: index)
            } else {
                items[index] = CartItem(
                    id: cartItem.id,
                    menuItem: cartItem.menuItem,
                    quantity: quantity,
                    placeName: cartItem.placeName
                )
            }
        }
    }

    func removeItem(_ cartItem: CartItem) {
        items.removeAll { $0.id == cartItem.id }
    }

    func clearCart() {
        items.removeAll()
    }
}
