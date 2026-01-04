////
//  LoginView.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 04/07/1447 AH.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // الخلفية
                Image("bg_topo_pattern")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 30) {
                    Text("Welcome back! Glad to see you, Again!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "D45E39"))
                        .padding(.top, 60)
                    
                    VStack(spacing: 18) {
                        // حقل رقم الموظف
                        CustomInputWrapper {
                            TextField("Enter your job number", text: $viewModel.jobNumber)
                                .keyboardType(.numberPad)
                        }
                        
                        // حقل كلمة المرور
                        CustomInputWrapper {
                            HStack {
                                if isPasswordVisible {
                                    TextField("Enter your password", text: $viewModel.password)
                                } else {
                                    SecureField("Enter your password", text: $viewModel.password)
                                }
                                Button(action: { isPasswordVisible.toggle() }) {
                                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    // رسالة الخطأ إن وجدت
                    if let error = viewModel.errorMessage {
                        Text(error).foregroundColor(.red).font(.caption)
                    }

                    // زر تسجيل الدخول
                    Button(action: {
                        Task { await viewModel.login() }
                    }) {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "232455"))
                    .cornerRadius(12)
                    // الانتقال للصفحة الرئيسية عند نجاح الدخول
                    .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                        MainView()
                    }
                    
                    Spacer()
                }
                .padding(25)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Subviews
struct CustomInputWrapper<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    
    var body: some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview
#Preview {
    LoginView()
}


















//
//import SwiftUI
//
//struct LoginView: View {
//    // MARK: - Properties
//    @State private var jobNumber: String = ""
//    @State private var password: String = ""
//    @State private var isPasswordVisible: Bool = false
//
//    var body: some View {
//        ZStack {
//            // MARK: Background Pattern
//            Image("bg_topo_pattern")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
//            
//            VStack(alignment: .leading, spacing: 30) {
//                
//                // MARK: Welcome Text
//                Text("Welcome back! Glad to see you, Again!")
//                    .font(.system(size: 32, weight: .bold))
//                    .foregroundColor(Color(hex: "D45E39")) // brandOrange
//                    .padding(.top, 60)
//                
//                VStack(spacing: 18) {
//                    // Job Number Field
//                    CustomInputWrapper {
//                        TextField("Enter your job number", text: $jobNumber)
//                    }
//                    
//                    // Password Field
//                    CustomInputWrapper {
//                        HStack {
//                            if isPasswordVisible {
//                                TextField("Enter your password", text: $password)
//                            } else {
//                                SecureField("Enter your password", text: $password)
//                            }
//                            
//                            Button(action: { isPasswordVisible.toggle() }) {
//                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                }
//                
//                // MARK: Login Button
//                Button(action: {
//                    // Login Action
//                }) {
//                    Text("Login")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color(hex: "232455")) // navyBlue
//                        .cornerRadius(12)
//                }
//                .padding(.top, 10)
//                
//                Spacer()
//            }
//            .padding(25)
//        }
//    }
//}
//
//// MARK: - Subviews
//struct CustomInputWrapper<Content: View>: View {
//    let content: Content
//    init(@ViewBuilder content: () -> Content) { self.content = content() }
//    
//    var body: some View {
//        content
//            .padding()
//            .background(Color.white)
//            .cornerRadius(12)
//            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    LoginView()
//}
