//
//  MainView.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 05/07/1447 AH.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @StateObject private var upcomingBookingVM = UpcomingBookingViewModel()

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "navyBlue")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    @State private var selectedDateIndex: Int = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color("systemGrayLight")
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // MARK: - Banner
                        ZStack {
                            Image("bg_banner_available")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(16)
                            
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("All board rooms")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.8))
                                    Text("Available today")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    
                                    NavigationLink(destination: Available()) {
                                        HStack(spacing: 4) {
                                            Text("Book now")
                                                .font(.system(size: 12, weight: .semibold))
                                            Image(systemName: "arrow.right.circle.fill")
                                                .font(.system(size: 22))
                                        }
                                        .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(35)
                            .frame(height: 180)
                        }
                        .padding(.horizontal)
                        
                        
                        // MARK: - My Booking
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("My booking")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color("navyBlue"))
                                
                                Spacer()
                                
                                NavigationLink(destination: MyBookingView()) {
                                    Text("See All")
                                        .font(.subheadline)
                                        .foregroundColor(Color("brandOrange"))
                                }
                            }
                            .padding(.horizontal)
                            
                            if let booking = upcomingBookingVM.nextBooking {
                                RoomCardView(
                                    imageName: "CreativeSpace",
                                    title: "Creative Space",
                                    floor: "Floor 5",
                                    capacity: "1",
                                    tag: formattedDate(booking.fields.date),
                                    tagColor: Color("navyBlue"),
                                    tagTextColor: .white,
                                    facilities: ["wifi"]
                                )
                                .padding(.horizontal)
                            } else {
                                Text("No upcoming bookings")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            }
                        }

                        // MARK: - Room List & Calendar
                        VStack(alignment: .leading, spacing: 15) {
                            Text("All bookings for \(viewModel.currentMonthName)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color("navyBlue"))
                                .padding(.horizontal)
                            
                            // الكالندر الديناميكي 👇
                        
                            // داخل الـ ScrollView للأيام:
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<viewModel.calendarDays.count, id: \.self) { index in
                                        let item = viewModel.calendarDays[index]
                                        DateItemView(
                                            day: item.dayName,
                                            date: item.dateNumber,
                                            isSelected: selectedDateIndex == index
                                        )
                                        .onTapGesture {
                                            selectedDateIndex = index
                                            // 👇 هنا ممكن تعمل فلترة أو تحميل بيانات الغرف لهذا التاريخ
                                            // viewModel.loadRooms(for: viewModel.calendarDays[index].dateNumber)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }

                            
                            // قائمة الغرف من API 👇
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else if viewModel.boardrooms.isEmpty {
                                VStack(spacing: 10) {
                                    Text("No rooms available")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                    Button("Refresh") {
                                        Task {
                                            await viewModel.fetchData()
                                        }
                                    }
                                    .font(.caption)
                                    .buttonStyle(.bordered)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            } else {
                                VStack(spacing: 16) {
                                    ForEach(viewModel.boardrooms) { room in
                                        NavigationLink(destination: RoomDetailsView(
                                            room: room.fields,
                                            calendarDays: viewModel.calendarDays
                                        )) {
                                            RoomCardView(
                                                imageName: getRoomImage(room.fields.name),
                                                title: room.fields.name,
                                                floor: "Floor \(room.fields.floor_no)",
                                                capacity: "\(room.fields.seat_no)",
                                                tag: "Available",
                                                tagColor: Color("successGreenLight"),
                                                tagTextColor: Color("successGreen"),
                                                facilities: getFacilityIcons(room.fields.facilities)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Board Rooms")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await upcomingBookingVM.loadUpcomingBooking()
            await viewModel.fetchData() // 👈 جلب الغرف من API
        }
    }
    
    // MARK: - Helper Functions
    func formattedDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
    
    func getRoomImage(_ roomName: String) -> String {
        switch roomName {
        case "Creative Space": return "CreativeSpace"
        case "Ideation Room": return "IdeationRoom"
        case "Inspiration Room": return "InspirationRoom"
        default: return "IdeationRoom"
        }
    }
    
    func getFacilityIcons(_ facilities: [String]) -> [String] {
        facilities.map { facility in
            switch facility.lowercased() {
            case "wi-fi": return "wifi"
            case "screen": return "desktopcomputer"
            case "microphone": return "mic"
            case "projector": return "video.fill"
            default: return "checkmark.circle"
            }
        }
    }
}

// MARK: - Room Card Component
struct RoomCardView: View {
    let imageName: String
    let title: String
    let floor: String
    let capacity: String
    let tag: String
    let tagColor: Color
    let tagTextColor: Color
    let facilities: [String]

    var body: some View {
        HStack(spacing: 15) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title).font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text(tag)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(tagColor).foregroundColor(tagTextColor).cornerRadius(6)
                }
                
                Text(floor).font(.caption).foregroundColor(Color("textSecondary"))
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                        Text(capacity)
                    }
                    .font(.system(size: 10, weight: .medium))
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color.gray.opacity(0.1)).cornerRadius(4)
                    .foregroundColor(Color("brandOrange"))

                    ForEach(facilities, id: \.self) { icon in
                        Image(systemName: icon).font(.system(size: 10)).foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(12)
        .background(Color("appWhite"))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Date Item Component
//struct DateItemView: View {
//    let day: String
//    let date: String
//    let isSelected: Bool
//    
//    var body: some View {
//        VStack(spacing: 6) {
//            Text(day)
//                .font(.caption)
//                .foregroundColor(.gray)
//            
//            Text(date)
//                .font(.headline)
//                .foregroundColor(isSelected ? .white : .primary)
//                .frame(width: 44, height: 44)
//                .background(isSelected ? Color(hex: "D45E39") : Color(.systemGray6))
//                .cornerRadius(22)
//        }
//    }
//}

// MARK: - Color Extension
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        
//        let r = Double((int >> 16) & 0xFF) / 255
//        let g = Double((int >> 8) & 0xFF) / 255
//        let b = Double(int & 0xFF) / 255
//        
//        self.init(red: r, green: g, blue: b)
//    }
//}

#Preview {
    MainView()
}
