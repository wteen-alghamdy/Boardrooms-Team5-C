//
//  MainView.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 05/07/1447 AH.
//

import SwiftUI

struct MainView: View {
    // MARK: - Mock Data
    let dates: [String] = ["16", "19", "20", "21", "22", "23", "26", "27", "28"]
    let days:  [String] = ["Thu", "Sun", "Mon", "Tue", "Wed", "Thu", "Sun", "Mon", "Tue"]

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: 1. Top Banner
                    ZStack(alignment: .leading) {
                        Image("bg_banner_available") // استدعاء من Assets
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                            .cornerRadius(20)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("All board rooms")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            Text("Available today")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            HStack {
                                Text("Book now")
                                    .font(.subheadline.bold())
                                Image(systemName: "arrow.right.circle.fill")
                            }
                            .foregroundColor(.white)
                        }
                        .padding(20)
                    }
                    
                    // MARK: 2. My Booking Section
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("My booking")
                                .font(.headline)
                                .foregroundColor(Color("navyBlue")) // استدعاء من Assets
                            Spacer()
                            Button("See All") {}.font(.caption).foregroundColor(Color("brandOrange"))
                        }
                        
                        RoomCardView(
                            imageName: "CreativeSpace",
                            title: "Creative Space",
                            floor: "Floor 5",
                            capacity: "1",
                            tag: "28 March",
                            tagColor: Color("navyBlue"),
                            tagTextColor: .white
                        )
                    }
                    
                    // MARK: 3. Calendar & All Bookings
                    VStack(alignment: .leading, spacing: 16) {
                        Text("All bookings for March")
                            .font(.headline)
                            .foregroundColor(Color("navyBlue"))
                        
                        // Horizontal Date Picker
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<dates.count, id: \.self) { index in
                                    // تم استدعاء الـ View المعرف مسبقاً في مشروعكم
                                    DateItemView(day: days[index], date: dates[index], isSelected: index == 0)
                                }
                            }
                        }
                        
                        // Rooms List
                        VStack(spacing: 16) {
                            RoomCardView(imageName: "CreativeSpace", title: "Creative Space", floor: "Floor 5", capacity: "1", tag: "Available", tagColor: Color("successGreenLight"), tagTextColor: Color("successGreen"))
                            
                            RoomCardView(imageName: "IdeationRoom", title: "Ideation Room", floor: "Floor 3", capacity: "16", tag: "Unavailable", tagColor: Color("errorRedLight"), tagTextColor: Color("errorRed"))
                            
                            RoomCardView(imageName: "InspirationRoom", title: "Inspiration Room", floor: "Floor 1", capacity: "18", tag: "Unavailable", tagColor: Color("errorRedLight"), tagTextColor: Color("errorRed"))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Board Rooms")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Reusable Components

struct RoomCardView: View {
    let imageName: String
    let title: String
    let floor: String
    let capacity: String
    let tag: String
    let tagColor: Color
    let tagTextColor: Color

    var body: some View {
        HStack(spacing: 15) {
            Image(imageName) // استدعاء من Assets
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title).font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text(tag)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(tagColor)
                        .foregroundColor(tagTextColor)
                        .cornerRadius(6)
                }
                
                Text(floor)
                    .font(.caption)
                    .foregroundColor(Color("textSecondary")) // استدعاء من Assets
                
                HStack(spacing: 12) {
                    Label(capacity, systemImage: "person.2")
                    Image(systemName: "wifi")
                    if title.contains("Ideation") { Image(systemName: "desktopcomputer") }
                    if title.contains("Inspiration") {
                        Image(systemName: "mic")
                        Image(systemName: "video")
                    }
                }
                .font(.caption2)
                .foregroundColor(Color("textDisabled")) // استدعاء من Assets
            }
        }
        .padding(12)
        .background(Color("appWhite")) // استدعاء من Assets
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Preview
#Preview {
    MainView()
}
