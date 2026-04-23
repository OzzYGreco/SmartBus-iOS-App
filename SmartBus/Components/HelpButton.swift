import SwiftUI

struct HelpButton: View {
    let content: HelpContent
    @State private var showingHelp = false

    var body: some View {
        Button(action: {
            showingHelp = true
        }) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                    )
                    .frame(width: 36, height: 36)

                Image(systemName: "questionmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .sheet(isPresented: $showingHelp) {
            HelpView(content: content)
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        HelpButton(content: HelpContentProvider.home)
    }
}
