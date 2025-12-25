//
//  MainViewModel.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 05/07/1447 AH.
//import Foundation

import Combine
class MainViewModel: ObservableObject {
    @Published var dates: [String] = ["16", "19", "20", "21", "22", "23", "26", "27", "28"]
    @Published var days: [String] = ["Thu", "Sun", "Mon", "Tue", "Wed", "Thu", "Sun", "Mon", "Tue"]
    
    func fetchData() {
        // سيتم ربط الـ API هنا لاحقاً
    }
}
