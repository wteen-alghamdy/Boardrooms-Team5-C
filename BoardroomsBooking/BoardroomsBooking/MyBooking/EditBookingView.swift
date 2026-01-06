import SwiftUI
import Foundation

struct EditBookingView: View {

    let room: BoardroomFields
    let booking: BookingRecord
    @ObservedObject var bookingVM: MyBookingViewModel
    @ObservedObject var mainVM: MainViewModel // ✅ أضف هذا السطر

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
            .padding(.top, -10)

            // MARK: Scrollable Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: Room Image with Gradient
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
                                if let url = URL(string: room.image_url) {
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
                                            Color.gray.opacity(0.3)
                                                .frame(height: 260)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Color.gray.opacity(0.3)
                                        .frame(height: 260)
                                }
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
                            Label("Floor \(room.floor_no)", systemImage: "building.2")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Spacer()

                            Label("\(room.seat_no)", systemImage: "person.2")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#D45E39"))
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }

                    // MARK: Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(room.description)
                                .font(.body)
                                .foregroundColor(.gray)
                                .padding()
                        }
                        .frame(maxHeight: 120)
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
                                    icon: mainVM.getIcon(for: facility),
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
                                    
                                    let dayName = formatDay(timestamp) // Fri, Sat, Sun...
                                    let isWeekend = (dayName == "Fri" || dayName == "Sat")

                                    let isAvailable = bookingVM.isRoomAvailable(
                                        boardroomID: booking.fields.boardroom_id,
                                        for: timestamp
                                    )

                                    DateItemView(
                                        day: dayName,
                                        date: formatDate(timestamp),
                                        isSelected: selectedIndex == index,
                                        isBooked: !isAvailable
                                    )
                                    .opacity(isWeekend ? 0.3 : 1.0)   // ✅ تظليل
                                    .onTapGesture {
                                        // ✅ منع الاختيار إذا ويكند
                                        if !isWeekend && isAvailable {
                                            selectedIndex = index
                                            selectedTimestamp = timestamp
                                        }
                                    }
                                }

                            }
                        }
                    }
                    .padding(.horizontal)
                    .task {
                        await mainVM.fetchFacilities()
                        await bookingVM.fetchBookings()
                    }

                    // MARK: Save Changes Button
                    Button {
                        Task {
                            guard let newDate = selectedTimestamp else { return }

                            await bookingVM.updateBooking(
                                recordID: booking.id,
                                newDate: Int(newDate)
                            )
                            
                            await bookingVM.fetchBookings()
                            presentationMode.wrappedValue.dismiss()
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
}
