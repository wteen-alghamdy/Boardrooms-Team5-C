////
////  mainCrad.swift
////  BoardroomsBooking
////
////  Created by Wed Ahmed Alasiri on 10/07/1447 AH.
////
//
//import Foundation
//import Combine
//
//struct UpcomingBookingAPIResponse: Decodable {
//    let records: [UpcomingBookingItem]
//}
//
//struct UpcomingBookingItem: Decodable, Identifiable {
//    let id: String
//    let fields: UpcomingBookingFields
//}
//
//struct UpcomingBookingFields: Decodable {
//    let boardroom_id: String
//    let date: TimeInterval
//}
//
//// MARK: - ViewModel
//
//@MainActor
//class UpcomingBookingViewModel: ObservableObject {
//
//    @Published var nextBooking: UpcomingBookingItem?
//
//    func loadUpcomingBooking() async {
//        // ✅ استرجاع employee_id من UserDefaults
//        guard let currentEmployeeID = UserDefaults.standard.string(forKey: "userEmployeeID"),
//              !currentEmployeeID.isEmpty else {
//            print("❌ No employee ID found - cannot fetch upcoming booking")
//            nextBooking = nil
//            return
//        }
//        
//        print("🔍 Fetching upcoming booking for employee: \(currentEmployeeID)")
//        
//        // ✅ إضافة فلتر للـ API
//        let urlString = "https://api.airtable.com/v0/appElKqRPusTLsnNe/bookings"
//        let filterFormula = "{employee_id}=\"\(currentEmployeeID)\""
//        guard let encodedFilter = filterFormula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//              let url = URL(string: "\(urlString)?filterByFormula=\(encodedFilter)") else {
//            print("❌ Failed to create URL")
//            nextBooking = nil
//            return
//        }
//        
//        print("🌐 API URL: \(url.absoluteString)")
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
//
//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            let response = try JSONDecoder().decode(UpcomingBookingAPIResponse.self, from: data)
//
//            // ✅ فلتر الحجوزات القادمة فقط
//            let now = Date().timeIntervalSince1970
//            let upcomingBookings = response.records.filter { booking in
//                booking.fields.date >= now
//            }
//
//            // ✅ أخذ أقرب حجز
//            self.nextBooking = upcomingBookings.sorted {
//                $0.fields.date < $1.fields.date
//            }.first
//
//            if let booking = nextBooking {
//                print("✅ Found upcoming booking: \(booking.id)")
//            } else {
//                print("ℹ️ No upcoming bookings found for user")
//            }
//
//        } catch {
//            print("❌ Upcoming booking error:", error)
//            nextBooking = nil
//        }
//    }
//}
