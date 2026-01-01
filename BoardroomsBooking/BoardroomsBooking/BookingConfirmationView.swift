import SwiftUI

struct BookingConfirmationView: View {
    let roomName: String
    let day: String
    let date: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Image("bg_topo_pattern")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer().frame(height: 60)
                    
                    Image("ic_success_gradient")
                        .resizable()
                        .frame(width: 300, height: 250)
                    
                    VStack(spacing: 10) {
                        Text("Booking Confirmed")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                        
                        Text("Your booking for \(roomName) on \(day), \(date) is confirmed.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                    }
                    
                    Spacer()
                    
                    Button {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            windowScene.windows.first?.rootViewController = UIHostingController(rootView: MainView())
                            windowScene.windows.first?.makeKeyAndVisible()
                        }
                    } label: {
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#D45E39"))
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}
