import Foundation
import Combine

@MainActor
final class MyBookingViewModel: ObservableObject {

    @Published var bookings: [BookingRecord] = []
    @Published var isLoading = false

    private let urlString = "https://api.airtable.com/v0/appElKqRPusTLsnNe/bookings"
    private let token = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    
    func fetchBookings() async {
        // استرجاع employee_id من UserDefaults
        guard let currentEmployeeID = UserDefaults.standard.string(forKey: "userEmployeeID"),
              !currentEmployeeID.isEmpty else {
            print("❌ No employee ID found - cannot fetch bookings")
            bookings = []
            return
        }
        
        print("🔍 Fetching bookings for employee: \(currentEmployeeID)")
        
        // ✅ إضافة فلتر للـ API لجلب حجوزات المستخدم فقط
        let filterFormula = "{employee_id}=\"\(currentEmployeeID)\""
        guard let encodedFilter = filterFormula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(urlString)?filterByFormula=\(encodedFilter)") else {
            print("❌ Failed to create URL")
            return
        }
        
        print("🌐 API URL: \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        isLoading = true

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(BookingResponse.self, from: data)
            bookings = decoded.records
            print("✅ Fetched \(bookings.count) bookings for current user (\(currentEmployeeID))")
        } catch {
            print("❌ API Error:", error)
            bookings = [] // في حالة الخطأ، نمسح القائمة
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

        print("📤 Sending booking request:")
        print("   - Employee ID: \(employeeID)")
        print("   - Boardroom ID: \(boardroomID)")
        print("   - Date: \(date)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                return false
            }
            
            print("📥 Response status code: \(httpResponse.statusCode)")
            
            if (200...299).contains(httpResponse.statusCode) {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("✅ Booking created successfully:")
                    print(responseJSON)
                }
                
                await fetchBookings()
                return true
            } else {
                if let errorJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("❌ API Error Response:")
                    print(errorJSON)
                }
                return false
            }

        } catch {
            print("❌ Booking failed with error:", error)
            return false
        }
    }

    func deleteBooking(recordID: String) async {
        let deleteURL = "\(urlString)/\(recordID)"
        
        guard let url = URL(string: deleteURL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            print("🗑️ Booking deleted: \(recordID)")
            
            await fetchBookings()
        } catch {
            print("❌ Delete failed:", error)
        }
    }
    
    func updateBooking(
        recordID: String,
        newDate: Int
    ) async {

        let updateURL = "\(urlString)/\(recordID)"
        guard let url = URL(string: updateURL) else { return }

        let body: [String: Any] = [
            "fields": [
                "date": newDate
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            print("✅ Booking updated: \(recordID)")
            await fetchBookings()
        } catch {
            print("❌ Update failed:", error)
        }
    }
    
    // ✅ دالة جديدة: استخراج أقرب حجز قادم
    var upcomingBooking: BookingRecord? {
        let now = Date().timeIntervalSince1970
        
        // فلتر الحجوزات القادمة فقط
        let upcoming = bookings.filter {
            TimeInterval($0.fields.date) >= now
        }
        
        // إرجاع أقرب حجز
        return upcoming.sorted {
            $0.fields.date < $1.fields.date
        }.first
    }
}


//
//enum BookingError: LocalizedError, Identifiable {
//    case missingEmployeeID
//    case invalidURL
//    case networkError
//    case decodingError
//    case serverError(statusCode: Int)
//    case unknown
//    
//    var id: String { localizedDescription }
//    
//    var errorDescription: String? {
//        switch self {
//        case .missingEmployeeID:
//            return "لم يتم العثور على بيانات المستخدم"
//        case .invalidURL:
//            return "الرابط غير صالح"
//        case .networkError:
//            return "تحقق من اتصال الإنترنت"
//        case .decodingError:
//            return "خطأ في قراءة البيانات"
//        case .serverError(let statusCode):
//            return "خطأ من الخادم (Code: \(statusCode))"
//        case .unknown:
//            return "حدث خطأ غير متوقع"
//        }
//    }
//}
