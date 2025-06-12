import SwiftUI

struct ConnectionView: View {
    @EnvironmentObject private var chatContext: ChatContext

    @State private var isConnecting: Bool = false
    private var tokenService: TokenService = .init()

    var body: some View {
        if chatContext.isConnected {
            ChatView()
        } else {
            VStack(spacing: 32) {
                Spacer()
                
                // MAAX avatar placeholder
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 96, height: 96)
                    Text("M")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("Hi, I'm MAAX!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                
                Text("Your friendly Medicare assistant. How can I help you today?")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Button(action: {
                    Task {
                        isConnecting = true
                        let roomName = "room-\(Int.random(in: 1000 ... 9999))"
                        let participantName = "user-\(Int.random(in: 1000 ... 9999))"
                        do {
                            if let connectionDetails = try await tokenService.fetchConnectionDetails(
                                roomName: roomName,
                                participantName: participantName
                            ) {
                                try await chatContext.connect(
                                    url: connectionDetails.serverUrl,
                                    token: connectionDetails.participantToken
                                )
                            } else {
                                print("Failed to fetch connection details")
                            }
                        } catch {
                            print("Connection error: \(error)")
                        }
                        isConnecting = false
                    }
                }) {
                    Text(isConnecting ? "Connecting..." : "Start Chat")
                        .font(.headline)
                        .frame(maxWidth: 280)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 4, y: 2)
                        .animation(.none, value: isConnecting)
                }
                .disabled(isConnecting)
                
                Spacer()
            }
            .padding()
            .background(
                Color.black
                    .ignoresSafeArea()
            )
        }
    }
}
