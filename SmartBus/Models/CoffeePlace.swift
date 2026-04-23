import Foundation

struct CoffeePlace: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let stops: Int
    let minutes: Int
    let menuItems: [MenuItem]

    static let samplePlaces: [CoffeePlace] = [
        CoffeePlace(
            name: "Starbucks",
            stops: 2,
            minutes: 10,
            menuItems: [
                MenuItem(name: "Espresso", description: "Arabica coffee beans", price: 2.50),
                MenuItem(name: "Capuccino", description: "Espresso, steamed milk, foam", price: 3.50),
                MenuItem(name: "Croissant", description: "Butter, flour, sugar", price: 2.00),
                MenuItem(name: "Sandwitch", description: "Bread, ham, cheese, lettuce", price: 4.50)
            ]
        ),
        CoffeePlace(
            name: "Costa Coffee",
            stops: 4,
            minutes: 16,
            menuItems: [
                MenuItem(name: "Americano", description: "Espresso with hot water", price: 2.80),
                MenuItem(name: "Latte", description: "Espresso with steamed milk", price: 3.20),
                MenuItem(name: "Muffin", description: "Blueberry muffin", price: 2.50),
                MenuItem(name: "Panini", description: "Grilled sandwich", price: 5.00)
            ]
        ),
        CoffeePlace(
            name: "Coffee Island",
            stops: 6,
            minutes: 20,
            menuItems: [
                MenuItem(name: "Freddo Espresso", description: "Iced espresso", price: 3.00),
                MenuItem(name: "Freddo Cappuccino", description: "Iced cappuccino with foam", price: 3.50),
                MenuItem(name: "Greek Coffee", description: "Traditional Greek coffee", price: 2.20),
                MenuItem(name: "Baklava", description: "Honey and nuts pastry", price: 3.00)
            ]
        ),
        CoffeePlace(
            name: "IL Toto",
            stops: 7,
            minutes: 23,
            menuItems: [
                MenuItem(name: "Ristretto", description: "Short espresso shot", price: 2.30),
                MenuItem(name: "Macchiato", description: "Espresso with milk foam", price: 2.80),
                MenuItem(name: "Tiramisu", description: "Classic Italian dessert", price: 4.00),
                MenuItem(name: "Biscotti", description: "Almond cookies", price: 2.50)
            ]
        ),
        CoffeePlace(
            name: "Everest",
            stops: 10,
            minutes: 36,
            menuItems: [
                MenuItem(name: "Filter Coffee", description: "Drip coffee", price: 2.00),
                MenuItem(name: "Mocha", description: "Espresso with chocolate", price: 3.80),
                MenuItem(name: "Chocolate Cake", description: "Rich chocolate cake", price: 3.50),
                MenuItem(name: "Club Sandwich", description: "Triple decker sandwich", price: 5.50)
            ]
        )
    ]
}
