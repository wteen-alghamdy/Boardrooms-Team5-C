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
    @StateObject private var bookingVM = MyBookingViewModel()
    @State private var selectedDateIndex: Int = 0

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "navyBlue")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("systemGrayLight").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        bannerView

                        myBookingSection

                        VStack(alignment: .leading, spacing: 15) {
                            Text("All bookings for \(viewModel.currentMonthName)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color("navyBlue"))
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<viewModel.calendarDays.count, id: \.self) { index in
                                        let item = viewModel.calendarDays[index]
                                        let isWeekend = (item.dayName == "Fri" || item.dayName == "Sat")
                                        
                                        DateItemView(
                                            day: item.dayName,
                                            date: item.dateNumber,
                                            isSelected: selectedDateIndex == index
                                        )
                                        .opacity(isWeekend ? 0.3 : 1.0)
                                        .onTapGesture {
                                            if !isWeekend {
                                                selectedDateIndex = index
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }

                            roomsListView
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Board Rooms")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
        .task {
            await upcomingBookingVM.loadUpcomingBooking()
            await viewModel.fetchData()
            await bookingVM.fetchBookings()
        }
    }

    // MARK: - Subviews
    
    private var bannerView: some View {
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
    }

    private var myBookingSection: some View {
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
    }

    private var roomsListView: some View {
        Group {
            if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity).padding()
            } else if isSelectedDateWeekend {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("The office is closed on weekends")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            } else if viewModel.boardrooms.isEmpty {
                VStack(spacing: 10) {
                    Text("No rooms available").foregroundColor(.gray).font(.caption)
                    Button("Refresh") { Task { await viewModel.fetchData() } }
                        .font(.caption).buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity).padding()
            } else {
                VStack(spacing: 16) {
                    ForEach(viewModel.boardrooms) { room in
                        let calendar = Calendar.current
                        let today = Date()
                        let selectedDate = calendar.date(byAdding: .day, value: selectedDateIndex, to: today) ?? today
                        let available = bookingVM.isRoomAvailable(boardroomID: room.id, for: selectedDate.timeIntervalSince1970)
                        
                        NavigationLink(destination: RoomDetailsView(
                            room: room.fields,
                            roomID: room.id,
                            calendarDays: viewModel.calendarDays,
                            bookingVM: bookingVM,
                            initialSelectedIndex: selectedDateIndex
                        )) {
                            RoomCardView(
                                imageName: getRoomImage(room.fields.name),
                                title: room.fields.name,
                                floor: "Floor \(room.fields.floor_no)",
                                capacity: "\(room.fields.seat_no)",
                                tag: available ? "Available" : "Unavailable",
                                tagColor: available ? Color("successGreenLight") : Color.red.opacity(0.1),
                                tagTextColor: available ? Color("successGreen") : Color.red,
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

    private var isSelectedDateWeekend: Bool {
        guard selectedDateIndex < viewModel.calendarDays.count else { return false }
        let day = viewModel.calendarDays[selectedDateIndex].dayName
        return day == "Fri" || day == "Sat"
    }

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
                
                Text(floor).font(.caption).foregroundColor(.gray)
                
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
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}







//
//import SwiftUI
//
//struct MainView: View {
//    @StateObject private var viewModel = MainViewModel()
//    @StateObject private var upcomingBookingVM = UpcomingBookingViewModel()
//    @StateObject private var bookingVM = MyBookingViewModel()
//    @State private var selectedDateIndex: Int = 0
//
//    init() {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(named: "navyBlue")
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
//    }
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color("systemGrayLight").ignoresSafeArea()
//
//                ScrollView(showsIndicators: false) {
//                    VStack(alignment: .leading, spacing: 25) {
//
//                        // MARK: - My Booking
//                        VStack(alignment: .leading, spacing: 15) {
//                            HStack {
//                                Text("My booking")
//                                    .font(.system(size: 18, weight: .bold))
//                                    .foregroundColor(Color("navyBlue"))
//
//                                Spacer()
//
//                                NavigationLink(destination: MyBookingView().environmentObject(viewModel)) {
//                                    Text("See All")
//                                        .font(.subheadline)
//                                        .foregroundColor(Color("brandOrange"))
//                                }
//                            }
//                            .padding(.horizontal)
//
//                            if let booking = upcomingBookingVM.nextBooking {
//                                RoomCardView(
//                                    imageName: "CreativeSpace",
//                                    title: "Creative Space",
//                                    floor: "Floor 5",
//                                    capacity: "1",
//                                    tag: formattedDate(booking.fields.date),
//                                    tagColor: Color("navyBlue"),
//                                    tagTextColor: .white,
//                                    facilities: ["wifi"]
//                                )
//                                .padding(.horizontal)
//                            } else {
//                                Text("No upcoming bookings")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                                    .padding(.horizontal)
//                            }
//                        }
//
//                        // MARK: - Room List & Calendar
//                        VStack(alignment: .leading, spacing: 15) {
//                            Text("All bookings for \(viewModel.currentMonthName)")
//                                .font(.system(size: 18, weight: .bold))
//                                .foregroundColor(Color("navyBlue"))
//                                .padding(.horizontal)
//
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack(spacing: 12) {
//                                    ForEach(0..<viewModel.calendarDays.count, id: \.self) { index in
//                                        let item = viewModel.calendarDays[index]
//                                        let isWeekend = (item.dayName == "Fri" || item.dayName == "Sat")
//
//                                        DateItemView(
//                                            day: item.dayName,
//                                            date: item.dateNumber,
//                                            isSelected: selectedDateIndex == index
//                                        )
//                                        .opacity(isWeekend ? 0.3 : 1.0)
//                                        .onTapGesture {
//                                            if !isWeekend {
//                                                selectedDateIndex = index
//                                            }
//                                        }
//                                    }
//                                }
//                                .padding(.horizontal)
//                            }
//
//                            roomsListView
//                        }
//                    }
//                    .padding(.vertical)
//                }
//            }
//            .navigationTitle("Board Rooms")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarBackButtonHidden(true)
//        }
//        .task {
//            await upcomingBookingVM.loadUpcomingBooking()
//            await viewModel.fetchData()
//            await bookingVM.fetchBookings()
//        }
//    }
//
//    // MARK: - Subviews
//
//    private var bannerView: some View {
//        ZStack {
//            Image("bg_banner_available")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(height: 180)
//                .frame(maxWidth: .infinity)
//                .clipped()
//                .cornerRadius(16)
//
//            VStack(alignment: .leading) {
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("All board rooms")
//                        .font(.system(size: 14))
//                        .foregroundColor(.white.opacity(0.8))
//                    Text("Available today")
//                        .font(.system(size: 28, weight: .bold))
//                        .foregroundColor(.white)
//                }
//                Spacer()
//                HStack {
//                    Spacer()
//                    NavigationLink(destination: Available()) {
//                        HStack(spacing: 4) {
//                            Text("Book now")
//                                .font(.system(size: 12, weight: .semibold))
//                            Image(systemName: "arrow.right.circle.fill")
//                                .font(.system(size: 22))
//                        }
//                        .foregroundColor(.white)
//                    }
//                }
//            }
//            .padding(35)
//            .frame(height: 180)
//        }
//        .padding(.horizontal)
//    }
//
//    private var myBookingSection: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            HStack {
//                Text("My booking")
//                    .font(.system(size: 18, weight: .bold))
//                    .foregroundColor(Color("navyBlue"))
//                Spacer()
//                NavigationLink(destination: MyBookingView()) {
//                    Text("See All")
//                        .font(.subheadline)
//                        .foregroundColor(Color("brandOrange"))
//                }
//            }
//            .padding(.horizontal)
//
//            if let booking = upcomingBookingVM.nextBooking {
//                RoomCardView(
//                    imageName: "CreativeSpace",
//                    title: "Creative Space",
//                    floor: "Floor 5",
//                    capacity: "1",
//                    tag: formattedDate(booking.fields.date),
//                    tagColor: Color("navyBlue"),
//                    tagTextColor: .white,
//                    facilities: ["wifi"]
//                )
//                .padding(.horizontal)
//            } else {
//                Text("No upcoming bookings")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
//            }
//        }
//    }
//
//    private var roomsListView: some View {
//        Group {
//            if viewModel.isLoading {
//                ProgressView().frame(maxWidth: .infinity).padding()
//            } else if isSelectedDateWeekend {
//                VStack(spacing: 12) {
//                    Image(systemName: "calendar.badge.clock")
//                        .font(.system(size: 40))
//                        .foregroundColor(.gray)
//                    Text("The office is closed on weekends")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.top, 40)
//            } else if viewModel.boardrooms.isEmpty {
//                VStack(spacing: 10) {
//                    Text("No rooms available").foregroundColor(.gray).font(.caption)
//                    Button("Refresh") { Task { await viewModel.fetchData() } }
//                        .font(.caption).buttonStyle(.bordered)
//                }
//                .frame(maxWidth: .infinity).padding()
//            } else {
//                VStack(spacing: 16) {
//                    ForEach(viewModel.boardrooms) { room in
//                        let calendar = Calendar.current
//                        let today = Date()
//                        let selectedDate = calendar.date(byAdding: .day, value: selectedDateIndex, to: today) ?? today
//                        let available = bookingVM.isRoomAvailable(boardroomID: room.id, for: selectedDate.timeIntervalSince1970)
//
//                        NavigationLink(destination: RoomDetailsView(
//                            room: room.fields,
//                            roomID: room.id,
//                            calendarDays: viewModel.calendarDays,
//                            bookingVM: bookingVM,
//                            initialSelectedIndex: selectedDateIndex
//                        )) {
//                            RoomCardView(
//                                imageName: getRoomImage(room.fields.name),
//                                title: room.fields.name,
//                                floor: "Floor \(room.fields.floor_no)",
//                                capacity: "\(room.fields.seat_no)",
//                                tag: available ? "Available" : "Unavailable",
//                                tagColor: available ? Color("successGreenLight") : Color.red.opacity(0.1),
//                                tagTextColor: available ? Color("successGreen") : Color.red,
//                                facilities: getFacilityIcons(room.fields.facilities)
//                            )
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                }
//                .padding(.horizontal)
//            }
//        }
//    }
//
//    private var isSelectedDateWeekend: Bool {
//        guard selectedDateIndex < viewModel.calendarDays.count else { return false }
//        let day = viewModel.calendarDays[selectedDateIndex].dayName
//        return day == "Fri" || day == "Sat"
//    }
//
//    func formattedDate(_ timestamp: TimeInterval) -> String {
//        let date = Date(timeIntervalSince1970: timestamp)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMM"
//        return formatter.string(from: date)
//    }
//
//    func getRoomImage(_ roomName: String) -> String {
//        switch roomName {
//        case "Creative Space": return "CreativeSpace"
//        case "Ideation Room": return "IdeationRoom"
//        case "Inspiration Room": return "InspirationRoom"
//        default: return "IdeationRoom"
//        }
//    }
//
//    func getFacilityIcons(_ facilities: [String]) -> [String] {
//        facilities.map { facility in
//            switch facility.lowercased() {
//            case "wi-fi": return "wifi"
//            case "screen": return "desktopcomputer"
//            case "microphone": return "mic"
//            case "projector": return "video.fill"
//            default: return "checkmark.circle"
//            }
//        }
//    }
//}
//
//// MARK: - Room Card Component
//struct RoomCardView: View {
//    let imageName: String
//    let title: String
//    let floor: String
//    let capacity: String
//    let tag: String
//    let tagColor: Color
//    let tagTextColor: Color
//    let facilities: [String]
//
//    var body: some View {
//        HStack(spacing: 15) {
//            Image(imageName)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 90, height: 90)
//                .cornerRadius(12)
//
//            VStack(alignment: .leading, spacing: 6) {
//                HStack {
//                    Text(title).font(.system(size: 16, weight: .bold))
//                    Spacer()
//                    Text(tag)
//                        .font(.system(size: 10, weight: .bold))
//                        .padding(.horizontal, 8).padding(.vertical, 4)
//                        .background(tagColor).foregroundColor(tagTextColor).cornerRadius(6)
//                }
//
//                Text(floor).font(.caption).foregroundColor(.gray)
//
//                HStack(spacing: 8) {
//                    HStack(spacing: 4) {
//                        Image(systemName: "person.2")
//                        Text(capacity)
//                    }
//                    .font(.system(size: 10, weight: .medium))
//                    .padding(.horizontal, 6).padding(.vertical, 2)
//                    .background(Color.gray.opacity(0.1)).cornerRadius(4)
//                    .foregroundColor(Color("brandOrange"))
//
//                    ForEach(facilities, id: \.self) { icon in
//                        Image(systemName: icon).font(.system(size: 10)).foregroundColor(.gray)
//                    }
//                }
//            }
//        }
//        .padding(12)
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
//    }
//}
