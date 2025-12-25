//
//  MainView.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 05/07/1447 AH.
//


import SwiftUI
struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "navyBlue")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("systemGrayLight")
                    .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                       
                        // MARK: - Banner Section
                        ZStack(alignment: .bottomTrailing) {
                            Image("bg_banner_available")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(16)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("All board rooms")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("Available today")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(25)
                            .frame(maxWidth: .infinity, maxHeight: 180, alignment: .topLeading)

                            HStack(spacing: 4) {
                                Text("Book now")
                                    .font(.system(size: 12, weight: .semibold))
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 24))
                            }
                            .foregroundColor(.white)
                            .padding(20)
                        }
                        .padding(.horizontal)

                        // MARK: - My Booking Section
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Text("My booking")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color("navyBlue"))
                                Spacer()
                                Button("See All") {}.font(.subheadline).foregroundColor(Color("brandOrange"))
                            }
                            .padding(.horizontal)
                            
                            RoomCardView(imageName: "CreativeSpace", title: "Creative Space", floor: "Floor 5", capacity: "1", tag: "28 March", tagColor: Color("navyBlue"), tagTextColor: .white, facilities: ["wifi"])
                                .padding(.horizontal)
                        }

                        // MARK: - All Bookings Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("All bookings for March")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color("navyBlue"))
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<viewModel.dates.count, id: \.self) { index in
                                        DateItemView(day: viewModel.days[index], date: viewModel.dates[index], isSelected: index == 0)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            VStack(spacing: 16) {
                                RoomCardView(imageName: "CreativeSpace", title: "Creative Space", floor: "Floor 5", capacity: "1", tag: "Available", tagColor: Color("successGreenLight"), tagTextColor: Color("successGreen"), facilities: ["wifi"])
                                
                                RoomCardView(imageName: "IdeationRoom", title: "Ideation Room", floor: "Floor 3", capacity: "16", tag: "Unavailable", tagColor: Color("errorRedLight"), tagTextColor: Color("errorRed"), facilities: ["wifi", "desktopcomputer"])
                                
                                RoomCardView(imageName: "InspirationRoom", title: "Inspiration Room", floor: "Floor 1", capacity: "18", tag: "Unavailable", tagColor: Color("errorRedLight"), tagTextColor: Color("errorRed"), facilities: ["wifi", "mic", "video.fill"])
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Board Rooms")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Components
struct RoomCardView: View {
    let imageName: String
    let title: String
    let floor: String
    let capacity: String
    let tag: String
    let tagColor: Color
    let tagTextColor: Color
    let facilities: [String]

    var body: some View {
        HStack(spacing: 15) {
            Image(imageName)
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
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(tagColor).foregroundColor(tagTextColor).cornerRadius(6)
                }
                
                Text(floor).font(.caption).foregroundColor(Color("textSecondary"))
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                        Text(capacity)
                    }
                    .font(.system(size: 10, weight: .medium))
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color.gray.opacity(0.1)).cornerRadius(4)
                    .foregroundColor(Color("brandOrange"))

                    ForEach(facilities, id: \.self) { icon in
                        Image(systemName: icon).font(.system(size: 10)).foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(12)
        .background(Color("appWhite"))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    MainView()
}
