import SwiftUI

struct PaymentDetailView: View {
    let paymentMethod: PaymentMethod
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingConfirmation = false

    var body: some View {
        Group {
            switch paymentMethod {
            case .applePay:
                ApplePayView(onComplete: completePayment)
            case .card:
                CardPaymentView(onComplete: completePayment)
            case .cash:
                CashPaymentView(onComplete: completePayment)
            }
        }
        .fullScreenCover(isPresented: $showingConfirmation) {
            OrderConfirmationView(paymentMethod: paymentMethod)
        }
    }

    private func completePayment() {
        showingConfirmation = true
    }
}

//Apple Pay View
struct ApplePayView: View {
    let onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartManager: CartManager
    @State private var isProcessing = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(width: 44, height: 44)

                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)

                Spacer()

                //Apple Pay logo
                VStack(spacing: 32) {
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 120, height: 120)

                        Image(systemName: "apple.logo")
                            .font(.system(size: 60, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)

                    Text("Apple Pay")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.black)

                    Text("Secure payment with Face ID")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                }

                Spacer()

                //Order summary
                VStack(spacing: 16) {
                    HStack {
                        Text("Items")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(cartManager.totalItems)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                    }

                    Divider()

                    HStack {
                        Text("Total")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(String(format: "€%.2f", cartManager.totalPrice))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.blue)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.08))
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                //Pay button
                Button(action: {
                    isProcessing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isProcessing = false
                        onComplete()
                    }
                }) {
                    HStack(spacing: 12) {
                        if isProcessing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 20))
                            Text("Pay with Apple Pay")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black)
                    )
                }
                .disabled(isProcessing)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

//Card Payment View
struct CardPaymentView: View {
    let onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartManager: CartManager
    @State private var cardNumber = ""
    @State private var cardHolder = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var isProcessing = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(width: 44, height: 44)

                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }

                    Spacer()

                    Text("Card Payment")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)

                    Spacer()

                    Circle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)

                ScrollView {
                    VStack(spacing: 24) {
                        //Card preview
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .font(.system(size: 32))
                                Spacer()
                                Image(systemName: "wave.3.right")
                                    .font(.system(size: 24))
                            }
                            .foregroundColor(.white)

                            Spacer()

                            Text(cardNumber.isEmpty ? "**** **** **** ****" : formatCardNumber(cardNumber))
                                .font(.system(size: 22, weight: .medium, design: .monospaced))
                                .foregroundColor(.white)

                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("CARD HOLDER")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(cardHolder.isEmpty ? "YOUR NAME" : cardHolder.uppercased())
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("EXPIRES")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                    Text(expiryDate.isEmpty ? "MM/YY" : expiryDate)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(24)
                        .frame(height: 200)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue,
                                    Color.blue.opacity(0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: Color.blue.opacity(0.4), radius: 20, x: 0, y: 10)

                        //Card form
                        VStack(spacing: 16) {
                            CustomTextField(
                                placeholder: "Card Number",
                                text: $cardNumber,
                                icon: "creditcard",
                                keyboardType: .numberPad
                            )

                            CustomTextField(
                                placeholder: "Card Holder Name",
                                text: $cardHolder,
                                icon: "person",
                                keyboardType: .default
                            )

                            HStack(spacing: 12) {
                                CustomTextField(
                                    placeholder: "MM/YY",
                                    text: $expiryDate,
                                    icon: "calendar",
                                    keyboardType: .numberPad
                                )

                                CustomTextField(
                                    placeholder: "CVV",
                                    text: $cvv,
                                    icon: "lock",
                                    keyboardType: .numberPad,
                                    isSecure: true
                                )
                            }
                        }

                        //Total
                        HStack {
                            Text("Total Amount")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                            Text(String(format: "€%.2f", cartManager.totalPrice))
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.08))
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }

                Spacer()
            }

            //Pay button at bottom
            VStack {
                Spacer()

                Button(action: {
                    isProcessing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isProcessing = false
                        onComplete()
                    }
                }) {
                    HStack(spacing: 12) {
                        if isProcessing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Pay Now")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isFormValid ? Color.blue : Color.gray)
                    )
                }
                .disabled(!isFormValid || isProcessing)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .background(Color.white)
            }
        }
        .navigationBarHidden(true)
    }

    private var isFormValid: Bool {
        !cardNumber.isEmpty && !cardHolder.isEmpty && !expiryDate.isEmpty && !cvv.isEmpty
    }

    private func formatCardNumber(_ number: String) -> String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        var formatted = ""
        for (index, char) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                formatted += " "
            }
            formatted += String(char)
        }
        return formatted
    }
}

//Cash Payment View
struct CashPaymentView: View {
    let onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartManager: CartManager
    @State private var isConfirming = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(width: 44, height: 44)

                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)

                Spacer()

                //Cash icon
                VStack(spacing: 32) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 120, height: 120)

                        Image(systemName: "banknote.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                    }

                    Text("Cash on Delivery")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)

                    Text("Pay when you receive your order")
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()

                //Order info
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        InfoRow(label: "Payment Method", value: "Cash")
                        InfoRow(label: "Items", value: "\(cartManager.totalItems)")

                        Divider()

                        HStack {
                            Text("Amount to Pay")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                            Text(String(format: "€%.2f", cartManager.totalPrice))
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.green)
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.08))
                    )

                    Text("Please keep exact change ready")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                //Confirm button
                Button(action: {
                    isConfirming = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isConfirming = false
                        onComplete()
                    }
                }) {
                    HStack(spacing: 12) {
                        if isConfirming {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Confirm Order")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.green)
                    )
                }
                .disabled(isConfirming)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

//Help Views
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .frame(width: 24)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .keyboardType(keyboardType)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .keyboardType(keyboardType)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.08))
        )
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    PaymentDetailView(paymentMethod: .applePay)
        .environmentObject(CartManager())
}
