import SwiftUI

struct LostItemsAlertView: View {
    @Binding var foundItems: [LostItem]
    let onDismiss: () -> Void

    @State private var showContent = false

    private var allItemsAlerted: Bool {
        foundItems.allSatisfy { $0.isAlerted }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.red.opacity(0.6),
                    Color.orange.opacity(0.7),
                    Color.red.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)

                //Warning icon
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 120, height: 120)

                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)

                    VStack(spacing: 8) {
                        Text("Lost Items Found!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)

                        Text("Please alert the driver for each item")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.bottom, 32)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : -20)

                //Items list
                VStack(spacing: 16) {
                    ForEach(foundItems.indices, id: \.self) { index in
                        LostItemRow(
                            item: foundItems[index],
                            onAlert: {
                                withAnimation {
                                    foundItems[index].isAlerted = true
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                //Warning message
                if !allItemsAlerted {
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)

                        Text("You must alert the driver for all items before continuing")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    .opacity(showContent ? 1 : 0)
                }

                Spacer()

                //Continue button
                Button(action: {
                    if allItemsAlerted {
                        onDismiss()
                    }
                }) {
                    Text(allItemsAlerted ? "Continue" : "Alert All Items First")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(allItemsAlerted ? Color.green : Color.gray.opacity(0.5))
                        )
                }
                .disabled(!allItemsAlerted)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct LostItemRow: View {
    let item: LostItem
    let onAlert: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: item.isAlerted ? "checkmark" : "questionmark")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }

            //Item info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.itemName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Text(item.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))

                Text("Found at seat \(item.seatNumber)")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            //Alert button
            Button(action: onAlert) {
                HStack(spacing: 6) {
                    Image(systemName: item.isAlerted ? "checkmark.circle.fill" : "bell.fill")
                        .font(.system(size: 16))

                    Text(item.isAlerted ? "Alerted" : "Alert")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(item.isAlerted ? .green : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(item.isAlerted ? Color.white : Color.white.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .disabled(item.isAlerted)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
        .opacity(item.isAlerted ? 0.7 : 1.0)
    }
}

#Preview {
    LostItemsAlertView(
        foundItems: .constant([
            LostItem(itemName: "Phone Charger", seatNumber: 5, description: "Black USB-C cable"),
            LostItem(itemName: "Water Bottle", seatNumber: 8, description: "Blue stainless steel bottle")
        ]),
        onDismiss: {}
    )
}
