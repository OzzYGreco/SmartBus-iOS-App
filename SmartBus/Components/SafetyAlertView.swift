import SwiftUI

struct SafetyAlertView: View {
    let alert: SafetyAlertType
    let onDismiss: () -> Void

    @State private var isAnimating = false

    var alertColor: Color {
        switch alert.color {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "blue": return .blue
        default: return .gray
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(alertColor.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.5 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )

                    Image(systemName: alert.icon)
                        .font(.title2)
                        .foregroundColor(alertColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(alert.rawValue)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(alert.message)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(alertColor.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(alertColor, lineWidth: 2)
                )
        )
        .shadow(color: alertColor.opacity(0.3), radius: 10)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        VStack(spacing: 20) {
            SafetyAlertView(alert: .speedLimit, onDismiss: {})
            SafetyAlertView(alert: .laneDeparture, onDismiss: {})
            SafetyAlertView(alert: .fatigue, onDismiss: {})
            SafetyAlertView(alert: .passengerBoarding, onDismiss: {})
        }
        .padding()
    }
}
