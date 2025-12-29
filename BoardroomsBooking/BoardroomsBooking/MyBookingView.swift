import SwiftUI

import Foundation




struct MyBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    //    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = MyBookingViewModel()
    var body: some View {
        
        ZStack {
            Image("bg_topo_pattern")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // HEADER
                ZStack {
                    Color(hex: "232455")
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("My Booking")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        Spacer().frame(width: 24)
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                }
                .frame(height: 110)
                .offset(y: -30)
                
                
                // LIST
                ScrollView {
                    LazyVStack(spacing: 16) {
                        
                        if vm.isLoading {
                            ProgressView()
                                .padding()
                        }
                        //                        ForEach(0..<5, id: \.self) { _ in
                        //                            BookingCard(dateText: "28 March")
                        //                        }
                        ForEach(vm.bookings) { booking in
                            BookingCard(
                                dateText: vm.formatDate(booking.fields.date)
                            )
                        }
                        
                        
                    }
                    .padding()
                }
            }
        }
        .task {
            await vm.fetchBookings()
        }
        
    }
    
    
    
    
    struct BookingCard: View {
        let dateText: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                
                Image("CreativeSpace")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Creative Space")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.3))
                        Spacer()
                        
                        Text(dateText)
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(dateText == "Available" ? Color("successGreenLight") : Color("navyBlue"))
                            .foregroundColor(dateText == "Available" ? Color("successGreen") : Color("systemGrayLight"))
                            .cornerRadius(6)
                        //                    
                        //                        .font(.caption2)
                        //                        .padding(.horizontal, 8)
                        //                        .padding(.vertical, 4)
                        //                        .background(Color(red: 0.15, green: 0.15, blue: 0.35))
                        //                        .foregroundColor(.white)
                        //                        .cornerRadius(6)
                    }
                    
                    Text("Floor 5")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                                .font(.system(size: 12))
                            Text("1")
                                .font(.caption)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .foregroundColor(.orange)
                        .cornerRadius(6)
                        
                        Image(systemName: "wifi")
                            .font(.system(size: 12))
                            .padding(6)
                            .background(Color.blue.opacity(0.05))
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
            .frame(width: 385, height: 140)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5)
        }
        
    }
    
}

#Preview {
    MyBookingView()
}
