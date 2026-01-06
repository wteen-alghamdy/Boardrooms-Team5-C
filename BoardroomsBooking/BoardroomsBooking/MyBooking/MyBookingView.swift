import SwiftUI
import Foundation

struct MyBookingView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.presentationMode) var presentationMode
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
                
                List {
                    ForEach(vm.bookings) { booking in
                        if let room = mainViewModel.boardrooms.first(where: { $0.id == booking.fields.boardroom_id }) {
                            NavigationLink {
                                EditBookingView(
                                    room: room.fields,           // ✅ room أولاً
                                    booking: booking,            // ✅ booking ثانياً
                                    bookingVM: vm,               // ✅ bookingVM ثالثاً
                                    mainVM: mainViewModel        // ✅ mainVM رابعاً
                                )
                            } label: {
                                BookingCard(
                                    booking: booking,
                                    room: room.fields,
                                    vm: vm
                                )
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task {
                                        await vm.deleteBooking(recordID: booking.id)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("My Booking")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .task {
            await vm.fetchBookings()
        }
    }
}

// MARK: - BookingCard Component
struct BookingCard: View {
    let booking: BookingRecord
    let room: BoardroomFields
    @ObservedObject var vm: MyBookingViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Room image
            AsyncImage(url: URL(string: room.image_url)) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.3)
                        .frame(width: 100, height: 100)
                        .cornerRadius(12)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(12)
                case .failure:
                    Color.gray.opacity(0.3)
                        .frame(width: 100, height: 100)
                        .cornerRadius(12)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(room.name)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.3))
                    Spacer()
                    
                    Text(vm.formatDate(booking.fields.date))
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "232455"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                
                Text("Floor \(room.floor_no)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                            .font(.system(size: 12))
                        Text("\(room.seat_no)")
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

#Preview {
    MyBookingView()
        .environmentObject(MainViewModel())
}
