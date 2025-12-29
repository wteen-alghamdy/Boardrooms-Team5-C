//
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
    private let token = "pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

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
            print("❌ API Error:", error)
        }

        isLoading = false
    }

    func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
}
