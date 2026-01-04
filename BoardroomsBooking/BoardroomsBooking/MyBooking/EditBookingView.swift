////
////  EditBookingView.swift
////  BoardroomsBooking
////
////  Created by Wed Ahmed Alasiri on 12/07/1447 AH.
////
//
//import SwiftUI
//import Foundation
//
//struct EditBookingView: View {
//
//    let booking: BookingRecord
//    @ObservedObject var bookingVM: MyBookingViewModel
//
//    // Pass the room fields if available so we can show the image
//    var room: BoardroomFields?
//
//    @State private var selectedIndex: Int = 0
//    @State private var selectedTimestamp: TimeInterval?
//
//    var body: some View {
//        VStack(spacing: 20) {
//
//            Text("Edit Booking")
//                .font(.headline)
//
//            if let imageURLString = room?.image_url, let url = URL(string: imageURLString) {
//                AsyncImage(url: url) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                            .frame(height: 200)
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .scaledToFill()
//                            .frame(height: 200)
//                            .cornerRadius(14)
//                            .clipped()
//                    case .failure(_):
//                        Image(systemName: "photo")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 200)
//                            .foregroundColor(.gray)
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//            }
//            
//            if let room = room {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text(room.name)
//                            .font(.title2)
//                            .fontWeight(.bold)
//
//                        HStack {
//                            Label("Floor \(room.floor_no)", systemImage: "building.2")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//
//                            Spacer()
//
//                            Label("\(room.seat_no) Seats", systemImage: "person.2")
//                                .font(.subheadline)
//                                .foregroundColor(Color(hex: "#D45E39"))
//                                .padding(6)
//                                .background(Color(.systemGray6))
//                                .cornerRadius(8)
//                        }
//
//                        // Description
//                        Text("Description")
//                            .font(.headline)
//                            .padding(.top, 4)
//
//                        Text(getDescription(for: room.name))
//                            .font(.body)
//                            .foregroundColor(.gray)
//                            .padding()
//                            .background(Color(.systemGray6))
//                            .cornerRadius(12)
//
//                        // Facilities
//                        Text("Facilities")
//                            .font(.headline)
//                            .padding(.top, 4)
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 12) {
//                                ForEach(room.facilities, id: \.self) { facility in
//                                    FacilityChip(
//                                        icon: getFacilityIcon(for: facility),
//                                        title: facility
//                                    )
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            // التقويم
//            ScrollView(.horizontal, showsIndicators: false) {
//                
//                
//                HStack(spacing: 14) {
//                    ForEach(0..<14, id: \.self) { index in
//                        let timestamp = getTimestampForDate(index: index)
//                        let isAvailable = bookingVM.isRoomAvailable(
//                            boardroomID: booking.fields.boardroom_id,
//                            for: timestamp
//                        )
//
//                        DateItemView(
//                            day: formatDay(timestamp),
//                            date: formatDate(timestamp),
//                            isSelected: selectedIndex == index,
//                            isBooked: !isAvailable
//                        )
//                        .onTapGesture {
//                            if isAvailable {
//                                selectedIndex = index
//                                selectedTimestamp = timestamp
//                            }
//                        }
//                    }
//                }
//            }
//
//            // زر حفظ التغير
//            Button {
//                Task {
//                    guard let newDate = selectedTimestamp else { return }
//
//                    await bookingVM.updateBooking(
//                        recordID: booking.id,
//                        newDate: Int(newDate)
//                    )
//                }
//            } label: {
//                Text("Save Changes")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color(hex: "D45E39"))
//                    .cornerRadius(14)
//            }
//
//            Spacer()
//        }
//        .padding()
//        .task {
//            await bookingVM.fetchBookings()
//        }
//        
//        
//        
//    }
//
//    // MARK: - Local Helpers
//    private func getTimestampForDate(index: Int) -> TimeInterval {
//        let calendar = Calendar.current
//        let today = Date()
//        let targetDate = calendar.date(byAdding: .day, value: index, to: today) ?? today
//        return targetDate.timeIntervalSince1970
//    }
//
//    private func formatDate(_ timestamp: TimeInterval) -> String {
//        let date = Date(timeIntervalSince1970: timestamp)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d" // يوم الشهر فقط
//        return formatter.string(from: date)
//    }
//
//    private func formatDay(_ timestamp: TimeInterval) -> String {
//        let date = Date(timeIntervalSince1970: timestamp)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE" // Thu, Fri ...
//        return formatter.string(from: date)
//    }
//    
//    // MARK: - Needed helpers copied locally
//    
//    private func getFacilityIcon(for facility: String) -> String {
//        switch facility.lowercased() {
//        case "wi-fi":
//            return "wifi"
//        case "screen":
//            return "tv"
//        case "microphone":
//            return "mic"
//        case "projector":
//            return "videoprojector"
//        default:
//            return "checkmark.circle"
//        }
//    }
//    
//    private func getDescription(for roomName: String) -> String {
//        switch roomName {
//        case "Creative Space":
//            return "A room designed to spark imagination and innovation, the Creative Space is perfect for small, focused meetings or one-on-one sessions. Featuring a minimalist design with warm tones, a cozy seating arrangement, and seamless Wi-Fi connectivity, this space fosters a relaxed yet professional atmosphere."
//        case "Ideation Room":
//            return "Specifically crafted for generating and refining ideas, the Ideation Room combines functionality with modern aesthetics. It features a high-resolution screen, writable wall surfaces for brainstorming, and comfortable seating for up to 16 participants."
//        case "Inspiration Room":
//            return "This versatile meeting room is equipped with everything you need to inspire and connect. With a large projector, a high-quality microphone, and ample seating for up to 18 people, the Inspiration Room is perfect for presentations, team discussions, and workshops."
//        default:
//            return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."
//        }
//    }
//}
//




import SwiftUI
import Foundation

struct EditBookingView: View {

    let booking: BookingRecord
    @ObservedObject var bookingVM: MyBookingViewModel
    var room: BoardroomFields?

    @State private var selectedIndex: Int = 0
    @State private var selectedTimestamp: TimeInterval?

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            // MARK: Header
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

                    Text("Edit Booking")
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

            // MARK: Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: Room Image with Gradient
                    if let imageURLString = room?.image_url, let url = URL(string: imageURLString) {
                        ZStack(alignment: .bottom) {
                            AsyncImage(url: url) { phase in
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
                                    Image(getRoomImage(room?.name ?? ""))
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

                            HStack {
                                Label("Floor \(room?.floor_no ?? 0)", systemImage: "building.2")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Spacer()

                                Label("\(room?.seat_no ?? 0)", systemImage: "person.2")
                                    .font(.subheadline)
                                    .foregroundColor(Color(hex: "#D45E39"))
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                        }
                    }

                    // MARK: Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)

                        Text(getDescription(for: room?.name ?? ""))
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
                            ForEach(room?.facilities ?? [], id: \.self) { facility in
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
                        Text("Select new date")
                            .font(.headline)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(0..<14, id: \.self) { index in
                                    let timestamp = getTimestampForDate(index: index)
                                    let isAvailable = bookingVM.isRoomAvailable(
                                        boardroomID: booking.fields.boardroom_id,
                                        for: timestamp
                                    )

                                    DateItemView(
                                        day: formatDay(timestamp),
                                        date: formatDate(timestamp),
                                        isSelected: selectedIndex == index,
                                        isBooked: !isAvailable
                                    )
                                    .onTapGesture {
                                        if isAvailable {
                                            selectedIndex = index
                                            selectedTimestamp = timestamp
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    // MARK: Save Changes Button
                    Button {
                        Task {
                            guard let newDate = selectedTimestamp else { return }

                            await bookingVM.updateBooking(
                                recordID: booking.id,
                                newDate: Int(newDate)
                            )
                        }
                    } label: {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#D45E39"))
                            .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)

                    Spacer(minLength: 30)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await bookingVM.fetchBookings()
        }
    }

    // MARK: - Helpers
    private func getTimestampForDate(index: Int) -> TimeInterval {
        let calendar = Calendar.current
        let today = Date()
        let targetDate = calendar.date(byAdding: .day, value: index, to: today) ?? today
        return targetDate.timeIntervalSince1970
    }

    private func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private func formatDay(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    private func getFacilityIcon(for facility: String) -> String {
        switch facility.lowercased() {
        case "wi-fi": return "wifi"
        case "screen": return "tv"
        case "microphone": return "mic"
        case "projector": return "videoprojector"
        default: return "checkmark.circle"
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
            return "Lorem Ipsum placeholder description."
        }
    }
}

// MARK: - Components
struct FacilityChip2: View {
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

struct DateItemView2: View {
    let day: String
    let date: String
    let isSelected: Bool
    var isBooked: Bool = false
    
    var body: some View {
        VStack(spacing: 6) {
            Text(day)
                .font(.caption)
                .foregroundColor(isBooked ? .gray.opacity(0.5) : .gray)
            
            Text(date)
                .font(.headline)
                .foregroundColor(isBooked ? .white : (isSelected ? .white : .primary))
                .frame(width: 44, height: 44)
                .background(
                    isBooked ? Color.gray : (isSelected ? Color(hex: "D45E39") : Color(.systemGray6))
                )
                .cornerRadius(22)
        }
        .opacity(isBooked ? 0.5 : 1.0)
    }
}


