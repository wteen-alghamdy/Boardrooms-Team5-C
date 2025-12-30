//
//  MyBookingModel.swift
//  BoardroomsBooking
//
//  Created by Wed Ahmed Alasiri on 09/07/1447 AH.
//

import Foundation
import Combine

struct BookingResponse: Decodable {
    let records: [BookingRecord]
}

struct BookingRecord: Decodable, Identifiable {
    let id: String
    let fields: BookingFields
}

struct BookingFields: Decodable {
    let employee_id: String
    let boardroom_id: String
    let date: TimeInterval
    let status: String?
}
 
