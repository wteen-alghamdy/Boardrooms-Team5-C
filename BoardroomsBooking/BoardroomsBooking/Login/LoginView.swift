import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg_topo_pattern")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        Text("Welcome back! Glad to see you, Again!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(hex: "D45E39"))
                            .padding(.top, 60)
                        
                        VStack(spacing: 18) {
                            CustomInputWrapper {
                                TextField("Enter your job number", text: $viewModel.jobNumber)
                                    .keyboardType(.numberPad)
                            }
                            
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
                        
                        // عرض رسالة الخطأ
                        if let errorMessage = viewModel.errorMessage {
                            HStack(spacing: 5) {
                                if errorMessage.contains("offline") {
                                    Image(systemName: "wifi.slash")
                                }
                                Text(errorMessage)
                            }
                            .foregroundColor(.red)
                            .font(.caption)
                        }

                        Button(action: {
                            Task {
                                await viewModel.login()
                            }
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
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
                            .contentShape(Rectangle())
                        }
                        .disabled(viewModel.isLoading)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(25)
                }
                .scrollDismissesKeyboard(.interactively) // ✅ إخفاء الكيبورد عند التمرير
            }
            .onTapGesture {
                hideKeyboard() // ✅ إخفاء الكيبورد عند الضغط على الشاشة
            }
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                MainView()
            }
        }
    }
    
    // ✅ دالة إخفاء الكيبورد
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

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

#Preview {
    LoginView()
}
