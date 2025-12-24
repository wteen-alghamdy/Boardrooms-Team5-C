//
//  Ideation Room.swift
//  BoardroomsBooking
//
//  Created by Wed Ahmed Alasiri on 04/07/1447 AH.
//

import SwiftUI

struct RoomDetailsView: View {

    let dates: [String] = ["16", "19", "20", "21", "22", "23", "26", "27", "28"]
    let days:  [String] = ["Thu", "Sun", "Mon", "Tue", "Wed", "Thu", "Sun", "Mon", "Tue"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: Header Image
                ZStack(alignment: .top) {
                    Image("room_image") // replace with your asset
                        .resizable()
                        .scaledToFill()
                        .frame(height: 260)
                        .clipped()

                    // Navigation Bar
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                        Text("Ideation Room")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        Spacer().frame(width: 44)
                    }
                    .padding(.top, 50)
                    .background(Color(hex: "232455"))
                }

                // MARK: Floor & Capacity
                HStack {
                    Label("Floor 3", systemImage: "paperplane")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Spacer()

                    Label("16", systemImage: "person.2")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                        .padding(8)
                        .background(Color.orange.opacity(0.15))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // MARK: Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)

                    Text("""
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type.
""")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                // MARK: Facilities
                VStack(alignment: .leading, spacing: 10) {
                    Text("Facilities")
                        .font(.headline)

                    HStack(spacing: 12) {
                        FacilityChip(icon: "wifi", title: "Wi-Fi")
                        FacilityChip(icon: "tv", title: "Screen")
                    }
                }
                .padding(.horizontal)

                // MARK: Calendar
                VStack(alignment: .leading, spacing: 12) {
                    Text("All bookings for March")
                        .font(.headline)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(0..<dates.count, id: \.self) { index in
                                DateItemView(
                                    day: days[index],
                                    date: dates[index],
                                    isSelected: index == 1
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // MARK: Booking Button
                Button(action: {}) {
                    Text("Booking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#D45E39"))
                        .cornerRadius(14)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: Components

struct FacilityChip: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(title)
        }
        .font(.subheadline)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct DateItemView: View {
    let day: String
    let date: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(day)
                .font(.caption)
                .foregroundColor(.gray)

            Text(date)
                .font(.headline)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 44, height: 44)
                .background(isSelected ? Color.orange : Color(.systemGray6))
                .cornerRadius(22)
        }
    }
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    RoomDetailsView()
}
