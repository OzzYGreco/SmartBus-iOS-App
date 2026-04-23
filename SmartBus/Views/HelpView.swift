import SwiftUI

struct HelpView: View {
    let content: HelpContent
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.6, blue: 1.0),
                    Color(red: 0.6, green: 0.4, blue: 0.9),
                    Color(red: 0.5, green: 0.5, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()

                    Text(content.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)

                // Help sections
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(content.sections.enumerated()), id: \.offset) { index, section in
                            HelpSectionCard(section: section)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(
                                    .easeOut(duration: 0.4).delay(Double(index) * 0.1),
                                    value: showContent
                                )
                        }

                        // Close button inside ScrollView
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Got it!")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.green)
                                )
                        }
                        .padding(.top, 24)
                        .padding(.bottom, 40)
                        .opacity(showContent ? 1 : 0)
                    }
                    .padding(.horizontal, 20)
                }

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3).delay(0.1)) {
                showContent = true
            }
        }
    }
}

struct HelpSectionCard: View {
    let section: HelpSection

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: section.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }

            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(section.action)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Text(section.description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
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
    }
}

#Preview {
    HelpView(content: HelpContentProvider.home)
}
