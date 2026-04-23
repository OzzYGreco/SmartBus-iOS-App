import Foundation
import SwiftUI

enum OrderStatus: String, CaseIterable {
    case placed = "Order Placed"
    case preparing = "Preparing Your Order"
    case ready = "Ready for Pickup"
    case outForDelivery = "Out for Delivery"
    case delivered = "Delivered"

    var icon: String {
        switch self {
        case .placed: return "checkmark.circle.fill"
        case .preparing: return "fork.knife.circle.fill"
        case .ready: return "bag.circle.fill"
        case .outForDelivery: return "bus.fill"
        case .delivered: return "checkmark.seal.fill"
        }
    }

    var color: Color {
        switch self {
        case .placed: return .blue
        case .preparing: return .orange
        case .ready: return .purple
        case .outForDelivery: return .cyan
        case .delivered: return .green
        }
    }

    var description: String {
        switch self {
        case .placed: return "Your order has been confirmed and is being processed"
        case .preparing: return "Our team is preparing your items with care"
        case .ready: return "Your order is ready for pickup at the counter"
        case .outForDelivery: return "Your order is on its way to you"
        case .delivered: return "Your order has been delivered. Enjoy!"
        }
    }
}

struct Order: Identifiable {
    let id: String
    let items: [CartItem]
    let totalPrice: Double
    let paymentMethod: PaymentMethod
    var status: OrderStatus
    let placedTime: Date
    let estimatedDeliveryMinutes: Int

    var estimatedDeliveryTime: Date {
        Calendar.current.date(byAdding: .minute, value: estimatedDeliveryMinutes, to: placedTime) ?? Date()
    }

    var statusTimeline: [OrderStatus] {
        OrderStatus.allCases
    }

    var currentStatusIndex: Int {
        OrderStatus.allCases.firstIndex(of: status) ?? 0
    }

    var timeRemaining: String {
        let now = Date()
        let remaining = estimatedDeliveryTime.timeIntervalSince(now)

        if remaining <= 0 {
            return "Arriving soon"
        }

        let minutes = Int(remaining / 60)
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            return "\(hours)h \(mins)m"
        }
    }
}
