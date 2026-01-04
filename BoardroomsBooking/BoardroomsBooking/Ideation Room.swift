import SwiftUI

struct RoomDetailsView: View {
    
    @State private var showConfirmation = false
    @State private var confirmationRoomName = ""
    @State private var confirmationDay = ""
    @State private var confirmationDate = ""
    
    let room: BoardroomFields
    let roomID: String
    let calendarDays: [(dayName: String, dateNumber: String)]
    @ObservedObject var bookingVM: MyBookingViewModel
    
    let initialSelectedIndex: Int
    @State private var selectedIndex: Int
    @State private var selectedDate: Int?
    
    @Environment(\.presentationMode) var presentationMode
    
    init(room: BoardroomFields,
         roomID: String,
         calendarDays: [(dayName: String, dateNumber: String)],
         bookingVM: MyBookingViewModel,
         initialSelectedIndex: Int = 0) {
        self.room = room
        self.roomID = roomID
        self.calendarDays = calendarDays
        self.bookingVM = bookingVM
        self.initialSelectedIndex = initialSelectedIndex
        _selectedIndex = State(initialValue: initialSelectedIndex)
    }
    
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
            .padding(.top, -10)

            // MARK: Scrollable Content
            VStack {
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
                        Text("All bookings for January")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(0..<calendarDays.count, id: \.self) { index in
                                    let item = calendarDays[index]
                                    let dateTimestamp = getTimestampForDate(index: index)
                                    let isAvailable = bookingVM.isRoomAvailable(
                                        boardroomID: roomID,
                                        for: dateTimestamp
                                    )

                                    DateItemView(
                                        day: item.dayName,
                                        date: item.dateNumber,
                                        isSelected: selectedIndex == index,
                                        isBooked: !isAvailable
                                    )
                                    .onTapGesture {
                                        if isAvailable {
                                            selectedDate = Int(item.dateNumber)
                                            selectedIndex = index
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .task {
                        await bookingVM.fetchBookings()
                    }
                    
                    // MARK: Booking Button
                    Button {
                        Task {
                            // ✅ قبل أي شي، نطبع كل اللي في UserDefaults
                            print("🔍 === CHECKING USERDEFAULTS ===")
                            print("All keys: \(UserDefaults.standard.dictionaryRepresentation().keys)")
                            
                            if let jobNum = UserDefaults.standard.string(forKey: "userJobNumber") {
                                print("✅ Found Job Number: \(jobNum)")
                            } else {
                                print("❌ No Job Number found")
                            }
                            
                            if let empID = UserDefaults.standard.string(forKey: "userEmployeeID") {
                                print("✅ Found Employee ID: \(empID)")
                            } else {
                                print("❌ No Employee ID found")
                            }
                            print("🔍 === END CHECKING ===")
                            
                            // استرجاع معرف الموظف
                            guard let employeeID = UserDefaults.standard.string(forKey: "userEmployeeID"),
                                  !employeeID.isEmpty else {
                                print("❌ CRITICAL: No valid employee ID!")
                                return
                            }
                            
                            print("📤 === CREATING BOOKING ===")
                            print("Employee ID: \(employeeID)")
                            print("Room ID: \(roomID)")
                            
                            let timestamp = getTimestampForDate(index: selectedIndex)
                            let success = await bookingVM.createBooking(
                                employeeID: employeeID,
                                boardroomID: roomID,
                                date: Int(timestamp)
                            )

                            if success {
                                await bookingVM.fetchBookings()

                                let fullDate = formatFullDate(timestamp)
                                confirmationRoomName = room.name
                                confirmationDay = fullDate.day
                                confirmationDate = fullDate.date

                                showConfirmation = true
                            } else {
                                print("❌ Booking failed")
                            }
                        }
                    } label: {
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
                    .fullScreenCover(isPresented: $showConfirmation) {
                        BookingConfirmationView(
                            roomName: room.name,
                            day: calendarDays[selectedIndex].dayName,
                            date: calendarDays[selectedIndex].dateNumber
                        )
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func formatFullDate(_ timestamp: TimeInterval) -> (day: String, date: String) {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        return (dayFormatter.string(from: date), dateFormatter.string(from: date))
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
    var isBooked: Bool = false
    
    var body: some View {
        VStack(spacing: 6) {
            Text(day)
                .font(.caption)
                .foregroundColor(isBooked ? .textSecondary.opacity(0.5) : .gray)
            
            Text(date)
                .font(.headline)
                .foregroundColor(isBooked ? .appWhite : (isSelected ? .white : .primary))
                .frame(width: 44, height: 44)
                .background(
                    isBooked
                        ? Color.textSecondary
                        : (isSelected ? Color(hex: "D45E39") : Color(.systemGray6))
                )
                .cornerRadius(22)
        }
        .opacity(isBooked ? 0.5 : 1.0)
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

// MARK: - Helper Function
private func getTimestampForDate(index: Int) -> TimeInterval {
    let calendar = Calendar.current
    let today = Date()
    let targetDate = calendar.date(byAdding: .day, value: index, to: today) ?? today
    return targetDate.timeIntervalSince1970
}
