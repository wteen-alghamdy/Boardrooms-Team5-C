import SwiftUI

struct BookingCard: View {
    var body: some View {
        
        
        ZStack {
            Color(hex:  "232455")
                .ignoresSafeArea(edges: .top)
            
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .offset(y: 30)

                }
                
                Spacer()
                
                Text("Ideation Room")
                    .font(.headline)
                    .foregroundColor(.white)
                    .offset(y: 40)

                Spacer()
                
                // Spacer وهمي لمعادلة زر الرجوع
                Spacer()
                    .frame(width: 24)
            }
            .padding(.horizontal)
            .padding(.top, 40) // مساحة الـ notch أو status bar
            .padding(.bottom, 12)
        }
        .frame(height: 160) // ارتفاع الهيدر
        
        ZStack{
            Image("bg_topo_pattern") // Ensure this name matches your Assets.xcassets
                .resizable()
                .aspectRatio(contentMode: .fill)
//                .ignoresSafeArea()
                .ignoresSafeArea(edges: .bottom)

            
            
            
            HStack(alignment: .top, spacing: 12) {
                
                
                
                // Placeholder for the workspace image
                Image("CreativeSpace") // Ensure you add an image to Assets
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Creative Space")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.3))
                        Spacer()
                        Text("28 March")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(red: 0.15, green: 0.15, blue: 0.35))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    
                    Text("Floor 5")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 12) {
                        // Capacity Icon/Text
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.system(size: 12))
                            Text("1")
                                .font(.caption)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .foregroundColor(.orange)
                        .cornerRadius(6)
                    }
                    
                    // Wifi Icon
                    Image(systemName: "wifi")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.3))
                        .padding(6)
                        .background(Color.blue.opacity(0.05))
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
}
struct MyBookingView: View {
    var body: some View {
        VStack(spacing: 0) {
            // ✅ الهيدر
//            ZStack {
//                Color(.black)
//                    .ignoresSafeArea(edges: .top)
//                
//                HStack {
//                    Button(action: {}) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.white)
//                    }
//                    
//                    Spacer()
//                    
//                    Text("Ideation Room")
//                        .font(.headline)
//                        .foregroundColor(.black)
//                    
//                    Spacer()
//                    
//                    // Spacer وهمي لمعادلة زر الرجوع
//                    Spacer()
//                        .frame(width: 24)
//                }
//                .padding(.horizontal)
//                .padding(.top, 40) // مساحة الـ notch أو status bar
//                .padding(.bottom, 12)
//            }
//            .frame(height: 90) // ارتفاع الهيدر

                
                
                // Content Area
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(0..<4) { _ in
                            BookingCard()
                        }
                    }
                    .padding()
                }
//                .background(
//                    // Replace with your topographic pattern image
//                    Image("topographic_pattern")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .opacity(0.4) // Adjust to match the subtle lines
//                        .edgesIgnoringSafeArea(.bottom)
//                )
            }
        }
    }


#Preview {
    BookingCard()
}
