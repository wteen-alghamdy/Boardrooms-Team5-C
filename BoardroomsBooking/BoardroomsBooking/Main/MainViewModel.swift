//
//  MainViewModel.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 05/07/1447 AH.
//import Foundation




import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var boardrooms: [BoardroomRecord] = []
    @Published var isLoading = false
    
    // متغيرات التاريخ الديناميكية
    @Published var currentMonthName: String = ""
    
    @Published var calendarDays: [(dayName: String, dateNumber: String)] = []
    private let urlString = "https://api.airtable.com/v0/appElKqRPusTLsnNe/boardrooms"
    private let token = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    init() {
        generateCurrentMonthCalendar()
    }

    
    func generateCurrentMonthCalendar() {
        let calendar = Calendar.current
        let today = Date()
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        self.currentMonthName = monthFormatter.string(from: today)
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        
        var tempDays: [(dayName: String, dateNumber: String)] = []
        for i in 0..<14 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                let dayName = dayFormatter.string(from: date)
                let dateNumber = String(calendar.component(.day, from: date))
                tempDays.append((dayName: dayName, dateNumber: dateNumber))
            }
        }
        self.calendarDays = tempDays
    }


    func fetchData() async {
        isLoading = true
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(BoardroomResponse.self, from: data)
            self.boardrooms = decoded.records
        } catch {
            print("❌ Error fetching rooms: \(error)")
        }
        isLoading = false
    }
}








//
//import Combine
//class MainViewModel: ObservableObject {
//    @Published var dates: [String] = ["16", "19", "20", "21", "22", "23", "26", "27", "28"]
//    @Published var days: [String] = ["Thu", "Sun", "Mon", "Tue", "Wed", "Thu", "Sun", "Mon", "Tue"]
//    
//    func fetchData() {
//        // سيتم ربط الـ API هنا لاحقاً
//    }
//}
