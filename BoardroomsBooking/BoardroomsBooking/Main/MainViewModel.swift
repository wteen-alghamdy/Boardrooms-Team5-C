

import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var boardrooms: [BoardroomRecord] = []
    @Published var facilityIcons: [String: String] = [:] // ✅ جديد
    @Published var isLoading = false
    @Published var currentMonthName: String = ""
    @Published var calendarDays: [(dayName: String, dateNumber: String)] = []
    @Published var errorMessage: String? = nil

    private let boardroomsURL = "https://api.airtable.com/v0/appElKqRPusTLsnNe/boardrooms"
    private let facilitiesURL = "https://api.airtable.com/v0/appElKqRPusTLsnNe/facilities" // ✅ جديد
    private let token = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    init() {
        generateCurrentMonthCalendar()
    }
    
    // ✅ دالة جديدة لجلب الـ facilities
    func fetchFacilities() async {
        guard let url = URL(string: facilitiesURL) else { return }
        
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(FacilityResponse.self, from: data)
            
            // تحويل الـ array لـ dictionary للبحث السريع
            var icons: [String: String] = [:]
            for record in decoded.records {
                icons[record.fields.name] = record.fields.icon
            }
            self.facilityIcons = icons
            
            print("✅ Loaded \(icons.count) facility icons")
            
        } catch {
            print("❌ Error fetching facilities: \(error)")
        }
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
        errorMessage = nil

        guard let url = URL(string: boardroomsURL) else {
            isLoading = false
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }

            let decoded = try JSONDecoder().decode(BoardroomResponse.self, from: data)
            self.boardrooms = decoded.records

        } catch {
            print("❌ Error fetching rooms: \(error)")
            self.boardrooms = []
            self.errorMessage = "No internet connection"
        }

        isLoading = false
    }
    
    // ✅ دالة مساعدة للحصول على الأيقونة
    func getIcon(for facility: String) -> String {
        return facilityIcons[facility] ?? "checkmark.circle"
    }
}
