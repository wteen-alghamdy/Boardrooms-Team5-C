//
//  mainCrad.swift
//  BoardroomsBooking
//
//  Created by Wed Ahmed Alasiri on 10/07/1447 AH.
//

import Foundation
import Combine



struct UpcomingBookingAPIResponse: Decodable {
    let records: [UpcomingBookingItem]
}

struct UpcomingBookingItem: Decodable, Identifiable {
    let id: String
    let fields: UpcomingBookingFields
}

struct UpcomingBookingFields: Decodable {
    let boardroom_id: String
    let date: TimeInterval
}

// MARK: - ViewModel

@MainActor
class UpcomingBookingViewModel: ObservableObject {

    @Published var nextBooking: UpcomingBookingItem?

    func loadUpcomingBooking() async {
        guard let url = URL(string: "https://api.airtable.com/v0/appElKqRPusTLsnNe/bookings") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")

//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            let response = try JSONDecoder().decode(UpcomingBookingAPIResponse.self, from: data)
//
//            let now = Date().timeIntervalSince1970
//
//            //  الحجوزات القادمة فقط
//            let upcoming = response.records.filter {
//                $0.fields.date > now
//            }
//
//            //  ترتيبها من الأقرب
//            let sorted = upcoming.sorted {
//                $0.fields.date < $1.fields.date
//            }
//
//            //  أقرب حجز
//            self.nextBooking = sorted.first
//
//        } catch {
//            print("Upcoming booking error:", error)
//        }
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(UpcomingBookingAPIResponse.self, from: data)

            // نأخذ كل الحجوزات بدون فلترة على الوقت
            let upcoming = response.records

            // ترتيبها من الأقرب للوقت الحالي
            let now = Date().timeIntervalSince1970
            let sorted = upcoming.sorted {
                abs($0.fields.date - now) < abs($1.fields.date - now)
            }

            // أقرب حجز سواء كان قديم أو جديد
            self.nextBooking = sorted.first

        } catch {
            print("Upcoming booking error:", error)
        }

    }
}
