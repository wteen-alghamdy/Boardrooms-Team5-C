//
//  RoomDetailsView.swift
//  BoardroomsBooking
//
//  Created by Wed Ahmed Alasiri on 04/07/1447 AH.
//

import SwiftUI

struct RoomDetailsView: View {
    let room: BoardroomFields
    let calendarDays: [(dayName: String, dateNumber: String)]
    @State private var selectedIndex: Int = 0
    
    @StateObject private var bookingVM = MyBookingViewModel()
    @State private var selectedDate: Int?

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Header - ثابت فوق
            ZStack(alignment: .top) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("Ideation Room")
                        .font(.headline)
                        .foregroundColor(.white)

                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 8)
                .frame(height: 60)
                .background(Color(hex: "232455"))
            }
            .padding(.top, -10) // 👈 هذا السطر

            // MARK: Scrollable Content
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Image & Info
                    ZStack(alignment: .bottom) {
                        
                        AsyncImage(url: URL(string: room.image_url)) { phase in
                            switch phase {
                            case .empty:
                                Color.gray.opacity(0.3)
                                    .frame(height: 260)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 260)
                                    .clipped()
                            case .failure:
                                Image(getRoomImage(room.name))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 260)
                                    .clipped()
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.95),
                                Color.white.opacity(0.7),
                                Color.white.opacity(0.4),
                                Color.clear
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: 140)
                        
                        VStack(spacing: 16) {
                            
                            HStack {
                                Spacer()
                                Spacer().frame(width: 24)
                            }
                            .padding(.top, 50)
                            .padding(.horizontal)
                            
                            HStack {
                                Label("Floor \(room.floor_no)", systemImage: "paperplane")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Label("\(room.seat_no)", systemImage: "person.2")
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "#D45E39"))
                                    .padding(8)
                                    .background(Color(hex: "#ffffff"))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 12)
                    }
                    
                    // MARK: Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(getDescription(for: room.name))
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // MARK: Facilities
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Facilities")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            ForEach(room.facilities, id: \.self) { facility in
                                FacilityChip(
                                    icon: getFacilityIcon(for: facility),
                                    title: facility
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: Calendar
                    VStack(alignment: .leading, spacing: 12) {
                        Text("All bookings for March")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(0..<calendarDays.count, id: \.self) { index in
                                    let item = calendarDays[index]

                                    DateItemView(
                                        day: item.dayName,
                                        date: item.dateNumber,
                                        isSelected: selectedIndex == index
                                    )
                                    .onTapGesture {
                                        selectedDate = Int(item.dateNumber)
                                        selectedIndex = index // 👈 هذا يخلي العنصر يتحدد ويظهر محدد

                                    }

                                }

                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: Booking Button
                    Button(action: {}) {
                        Text("Booking")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#D45E39"))
                            .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    .padding(.top, -5)
                }
            }
        }
      //  .ignoresSafeArea(edges: .top)
        .navigationBarHidden(true)
    }
    
    // MARK: - Helper Functions
    
    private func getFacilityIcon(for facility: String) -> String {
        switch facility.lowercased() {
        case "wi-fi":
            return "wifi"
        case "screen":
            return "tv"
        case "microphone":
            return "mic"
        case "projector":
            return "videoprojector"
        default:
            return "checkmark.circle"
        }
    }
    
    private func getRoomImage(_ roomName: String) -> String {
        switch roomName {
        case "Creative Space": return "CreativeSpace"
        case "Ideation Room": return "IdeationRoom"
        case "Inspiration Room": return "InspirationRoom"
        default: return "IdeationRoom"
        }
    }
    
    private func getDescription(for roomName: String) -> String {
        switch roomName {
        case "Creative Space":
            return "A room designed to spark imagination and innovation, the Creative Space is perfect for small, focused meetings or one-on-one sessions. Featuring a minimalist design with warm tones, a cozy seating arrangement, and seamless Wi-Fi connectivity, this space fosters a relaxed yet professional atmosphere."
        case "Ideation Room":
            return "Specifically crafted for generating and refining ideas, the Ideation Room combines functionality with modern aesthetics. It features a high-resolution screen, writable wall surfaces for brainstorming, and comfortable seating for up to 16 participants."
        case "Inspiration Room":
            return "This versatile meeting room is equipped with everything you need to inspire and connect. With a large projector, a high-quality microphone, and ample seating for up to 18 people, the Inspiration Room is perfect for presentations, team discussions, and workshops."
        default:
            return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."
        }
    }
}

// MARK: - Components

struct FacilityChip: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(title)
        }
        .font(.subheadline)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct DateItemView: View {
    let day: String
    let date: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            Text(day)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(date)
                .font(.headline)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 44, height: 44)
                .background(isSelected ? Color(hex: "D45E39") : Color(.systemGray6))
                .cornerRadius(22)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    let sampleRoom = BoardroomFields(
        name: "Ideation Room",
        floor_no: 3,
        seat_no: 16,
        facilities: ["Wi-Fi", "Screen"],
        image_url: "https://firebasestorage.googleapis.com/v0/b/nanochallenge2-9404d.appspot.com/o/Ideation%20Room.png?alt=media&token=1663b37c-edaf-43a2-a4f7-9dd2badf17ca"
    )
    
    let sampleCalendar = [
        (dayName: "Thu", dateNumber: "16"),
        (dayName: "Sun", dateNumber: "19"),
        (dayName: "Mon", dateNumber: "20")
    ]
    
    RoomDetailsView(room: sampleRoom, calendarDays: sampleCalendar)
}
