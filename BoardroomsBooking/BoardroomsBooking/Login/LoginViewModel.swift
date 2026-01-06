import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var jobNumber: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let urlString = "https://api.airtable.com/v0/appElKqRPusTLsnNe/employees"
    private let token = "Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001"

    func login() async {
        guard !jobNumber.isEmpty && !password.isEmpty else {
            errorMessage = "please enter your job number and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let filterFormula = "AND({EmployeeNumber}=\(jobNumber), {password}=\"\(password)\")"
        guard let encodedFilter = filterFormula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(urlString)?filterByFormula=\(encodedFilter)") else { return }

        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(EmployeeResponse.self, from: data)
            
            if let employee = decoded.records.first {
                UserDefaults.standard.set(String(employee.fields.EmployeeNumber), forKey: "userJobNumber")
                UserDefaults.standard.set(employee.id, forKey: "userEmployeeID")
                isLoggedIn = true
            } else {
                errorMessage = "incorrect login details"
            }
            
        } catch let error as NSError {
            // معالجة خطأ انقطاع الإنترنت
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                errorMessage = "You are offline. Please check your internet connection."
            } else {
                errorMessage = "error connecting to the server"
            }
        }
        isLoading = false
    }
}










