import LiveKit
import LiveKitComponents
import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatContext: ChatContext
    @EnvironmentObject var room: Room
    @State private var animateActionBar = false

    var body: some View {
        VStack(spacing: 0) {
            // Header with MAAX avatar and name
            HStack(spacing: 16) {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("M")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                Text("MAAX")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal)
            .background(Color.black)

            Spacer()

            // Subtitle
            Text("MAAX is a Medicare voice assistant for agents.\nBy Samay")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 8)

            Spacer()

            ZStack(alignment: room.localParticipant.isCameraEnabled() ? .top : .center) {
                VStack(alignment: .center) {
                    Spacer()

                    CameraView()
                        .frame(
                            width: CGFloat(chatContext.cameraDimensions.width) / UIScreen.main.scale,
                            height: CGFloat(chatContext.cameraDimensions.height) / UIScreen.main.scale
                        )
                        .opacity(room.localParticipant.isCameraEnabled() ? 1 : 0)
                        .animation(.snappy, value: room.localParticipant.isCameraEnabled())

                    ActionBarView()
                        .opacity(animateActionBar ? 1 : 0)
                        .offset(y: animateActionBar ? 0 : 10)
                        .animation(.easeOut(duration: 0.2), value: animateActionBar)
                        .onAppear {
                            animateActionBar = true
                        }
                }

                AgentView()
                    .frame(
                        width: room.localParticipant.isCameraEnabled() ? 100 : UIScreen.main.bounds.width - 64,
                        height: room.localParticipant.isCameraEnabled() ? 100 : UIScreen.main.bounds.width - 64
                    )
                    .offset(y: room.localParticipant.isCameraEnabled() ? 0 : -40)
                    .animation(.snappy, value: room.localParticipant.isCameraEnabled())
            }
            .background(
                Color.black
                    .ignoresSafeArea()
            )
        }
    }
}
