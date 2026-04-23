import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable {
    case applePay = "Apple Pay"
    case card = "Credit/Debit Card"
    case cash = "Cash on Delivery"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .applePay: return "apple.logo"
        case .card: return "creditcard.fill"
        case .cash: return "banknote.fill"
        }
    }
}
