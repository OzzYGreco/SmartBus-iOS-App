import Foundation

struct LostItem: Identifiable {
    let id = UUID()
    let itemName: String
    let seatNumber: Int
    let description: String
    var isAlerted: Bool = false

    init(itemName: String, seatNumber: Int, description: String) {
        self.itemName = itemName
        self.seatNumber = seatNumber
        self.description = description
        self.isAlerted = false
    }
}
