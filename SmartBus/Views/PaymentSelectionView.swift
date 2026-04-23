import SwiftUI

struct PaymentSelectionView: View {
    @EnvironmentObject var cartManager: CartManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMethod: PaymentMethod?
    @State private var showingPaymentDetail = false
    @State private var showingHelp = false

    var body: some View{
        NavigationStack {
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

                        Text("Payment Method")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)

                        Spacer()

                        Button(action: {
                            showingHelp = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.25))
                                    .frame(width: 44, height: 44)

                                Image(systemName: "questionmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 24)

                    //Payment methods
                    VStack(spacing: 16) {
                        ForEach(PaymentMethod.allCases) { method in
                            PaymentMethodCard(
                                method: method,
                                isSelected: selectedMethod == method,
                                action: {
                                    selectedMethod = method
                                    showingPaymentDetail = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()

                    // Total info
                    VStack(spacing: 12) {
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
                                .fill(Color.gray.opacity(0.1))
                        )
                    }
                    .padding(20)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingPaymentDetail) {
                if let method = selectedMethod {
                    PaymentDetailView(paymentMethod: method)
                }
            }
            .sheet(isPresented: $showingHelp) {
                HelpView(content: HelpContentProvider.payment)
            }
        }
    }
}

struct PaymentMethodCard: View {
    let method: PaymentMethod
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                //Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 60, height: 60)

                    Image(systemName: method.icon)
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                }

                //Method name
                Text(method.rawValue)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                //Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}

#Preview {
    PaymentSelectionView()
        .environmentObject(CartManager())
}
