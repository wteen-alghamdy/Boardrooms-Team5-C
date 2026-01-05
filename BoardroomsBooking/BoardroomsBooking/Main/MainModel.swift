//
//  MainModel.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 10/07/1447 AH.
//

import Foundation

struct BoardroomResponse: Decodable {
    let records: [BoardroomRecord]
}

struct BoardroomRecord: Decodable, Identifiable {
    let id: String
    let fields: BoardroomFields
}

struct BoardroomFields: Decodable {
  //  let id: String      // ← أضف هذا
    let name: String
    let floor_no: Int
    let seat_no: Int
    let facilities: [String]
    let image_url: String
    let description: String   // ✅ جديد

}

// MARK: - Facility Models
struct FacilityRecord: Codable {
    let id: String
    let fields: FacilityFields
}

struct FacilityFields: Codable {
    let name: String
    let icon: String
}

struct FacilityResponse: Codable {
    let records: [FacilityRecord]
}
