//
//  EditBookingView.swift
//  BoardroomsBooking
//
//  Created by Wed Ahmed Alasiri on 12/07/1447 AH.
//
import SwiftUI
import Foundation

struct EditBookingView: View {

    let booking: BookingRecord
    @ObservedObject var bookingVM: MyBookingViewModel

    @State private var selectedIndex: Int = 0
    @State private var selectedTimestamp: TimeInterval?

    var body: some View {
        VStack(spacing: 20) {

            Text("Edit Booking")
                .font(.headline)

            // التقويم
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

            // زر حفظ التغير
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
                    .background(Color(hex: "D45E39"))
                    .cornerRadius(14)
            }

            Spacer()
        }
        .padding()
        .task {
            await bookingVM.fetchBookings()
        }
    }

    // MARK: - Local Helpers
//    private func formatDay(_ timestamp: TimeInterval) -> String {
//        let date = Date(timeIntervalSince1970: timestamp)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE"
//        return formatter.string(from: date)
//    }
//
//    private func formatDate(_ timestamp: TimeInterval) -> String {
//        let date = Date(timeIntervalSince1970: timestamp)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d"
//        return formatter.string(from: date)
//    }
    private func getTimestampForDate(index: Int) -> TimeInterval {
        let calendar = Calendar.current
        let today = Date()
        let targetDate = calendar.date(byAdding: .day, value: index, to: today) ?? today
        return targetDate.timeIntervalSince1970
    }

    private func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // يوم الشهر فقط
        return formatter.string(from: date)
    }

    private func formatDay(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // Thu, Fri ...
        return formatter.string(from: date)
    }
}
