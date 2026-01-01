
//  MyBookingViewModel.swift
//  BoardroomsBooking
//
//  Created by Wed Ahmed Alasiri on 09/07/1447 AH.
//

import Foundation
import Combine

@MainActor
final class MyBookingViewModel: ObservableObject {

    @Published var bookings: [BookingRecord] = []
    @Published var isLoading = false

    private let urlString = "https://api.airtable.com/v0/appElKqRPusTLsnNe/bookings"
    private let token = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    func fetchBookings() async {
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        isLoading = true

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(BookingResponse.self, from: data)
            bookings = decoded.records
        } catch {
            print(" API Error:", error)
        }

        isLoading = false
    }

    func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
    
    func isRoomAvailable(
        boardroomID: String,
        for selectedDate: TimeInterval
    ) -> Bool {

        let calendar = Calendar.current
        let selected = Date(timeIntervalSince1970: selectedDate)

        return !bookings.contains { booking in
            guard booking.fields.boardroom_id == boardroomID else {
                return false
            }

            let bookingDate = Date(timeIntervalSince1970: TimeInterval(booking.fields.date))
            return calendar.isDate(bookingDate, inSameDayAs: selected)
        }
    }

    
    
    
    
    func createBooking(
        employeeID: String,
        boardroomID: String,
        date: Int
    ) async -> Bool {

        guard let url = URL(string: urlString) else { return false }

        let body: [String: Any] = [
            "records": [
                [
                    "fields": [
                        "employee_id": employeeID,
                        "boardroom_id": boardroomID,
                        "date": date
                    ]
                ]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("❌ Invalid response")
                return false
            }

            await fetchBookings()
            return true

        } catch {
            print("❌ Booking failed:", error)
            return false
        }
    }

   
    
    
//    func formatFullDate(_ timestamp: TimeInterval) -> (day: String, date: String) {
//        let date = Date(timeIntervalSince1970: timestamp)
//        
//        let dayFormatter = DateFormatter()
//        dayFormatter.dateFormat = "EEEE" // Sunday, Monday ...
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM d, yyyy" // March 19, 2023
//        
//        return (dayFormatter.string(from: date), dateFormatter.string(from: date))
//    }

    
    

    func deleteBooking(recordID: String) async {
        let deleteURL = "\(urlString)/\(recordID)"
        
        guard let url = URL(string: deleteURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            print("🗑️ Booking deleted")
            
            // نحدث القائمة بعد الحذف
            await fetchBookings()
        } catch {
            print("❌ Delete failed:", error)
        }
    }

}


