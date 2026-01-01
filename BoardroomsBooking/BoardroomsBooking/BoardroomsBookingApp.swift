//
//  BoardroomsBookingApp.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 04/07/1447 AH.
//

import SwiftUI

@main
struct BoardroomsBookingApp: App {
    @AppStorage("userJobNumber") var userJobNumber: String?

    var body: some Scene {
        WindowGroup {
            if userJobNumber != nil {
                MainView()
            } else {
                LoginView()
            }
        }
    }
}
