//
//  LoginViewModel.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 04/07/1447 AH.
//

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
            errorMessage = "يرجى إدخال رقم الموظف وكلمة المرور"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(EmployeeResponse.self, from: data)
            
            // البحث عن الموظف ومطابقة الرقم والكلمة
            if let employee = decoded.records.first(where: {
                String($0.fields.EmployeeNumber) == jobNumber && $0.fields.password == password
            }) {
                UserDefaults.standard.set(String(employee.fields.EmployeeNumber), forKey: "userJobNumber")
                isLoggedIn = true
            } else {
                errorMessage = "بيانات الدخول غير صحيحة"
            }
        } catch {
            print("❌ Error: \(error)")
            errorMessage = "حدث خطأ في الاتصال بالسيرفر"
        }
        isLoading = false
    }
}
