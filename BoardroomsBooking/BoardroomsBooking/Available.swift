//
//  Available.swift
//  BoardroomsBooking
//
//  Created by Sarah on 05/07/1447 AH.
//

//}
import SwiftUI

struct Available: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mainViewModel: MainViewModel
    @StateObject private var bookingVM = MyBookingViewModel()
    
  
    var selectedDateIndex: Int = 0

    var body: some View {
        ZStack {
            Image("bg_topo_pattern")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Header
                ZStack {
                    Color(hex: "232455")
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Text("Available Rooms")
                            .font(.headline)
                            .foregroundColor(.white)

                        Spacer()
                        Spacer().frame(width: 24)
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                }
                .frame(height: 110)
                .offset(y: -30)

                // MARK: - Content
                ScrollView {
                    if mainViewModel.isLoading || bookingVM.isLoading {
                        ProgressView("Checking availability...")
                            .padding(.top, 50)
                    } else {
                        LazyVStack(spacing: 16) {
                            // حساب التوقيت بناءً على اليوم المختار من التقويم
                            let calendar = Calendar.current
                            let targetDate = calendar.date(byAdding: .day, value: selectedDateIndex, to: Date()) ?? Date()
                            let targetTimestamp = calendar.startOfDay(for: targetDate).timeIntervalSince1970
                            
                            // فلترة الغرف: عرض فقط الغرف التي لا تملك حجزاً في التاريخ المحدد
                            let availableRooms = mainViewModel.boardrooms.filter { room in
                                bookingVM.isRoomAvailable(boardroomID: room.id, for: targetTimestamp)
                            }
                            
                            if availableRooms.isEmpty {
                                VStack(spacing: 20) {
                                    Image(systemName: "calendar.badge.exclamationmark")
                                        .font(.system(size: 60))
                                        .foregroundColor(.gray)
                                    Text("No rooms available for this date.")
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 100)
                            } else {
                                ForEach(availableRooms) { room in
                                    NavigationLink(destination: RoomDetailsView(
                                        room: room.fields,
                                        roomID: room.id,
                                        calendarDays: mainViewModel.calendarDays,
                                        bookingVM: bookingVM,
                                        initialSelectedIndex: selectedDateIndex
                                    )) {
                                        AvailableRoomCard(room: room.fields)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            // جلب البيانات لضمان المزامنة مع Airtable
            if mainViewModel.boardrooms.isEmpty {
                await mainViewModel.fetchData()
            }
            await bookingVM.fetchBookings()
        }
    }
}

// MARK: - AvailableRoomCard Component
struct AvailableRoomCard: View {
    let room: BoardroomFields
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: room.image_url)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                default:
                    Color.gray.opacity(0.2)
                }
            }
            .frame(width: 90, height: 90)
            .cornerRadius(12)
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(room.name)
                    .font(.headline)
                    .foregroundColor(Color(hex: "232455"))
                
                Text("Floor \(room.floor_no)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Label("\(room.seat_no)", systemImage: "person.2")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(6)
                    
                    Text("Available")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.green)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .bold))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}
