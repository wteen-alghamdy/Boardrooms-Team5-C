//
//  LoginModel.swift
//  BoardroomsBooking
//
//  Created by Wteen Alghamdy on 10/07/1447 AH.
//

import Foundation

struct EmployeeResponse: Decodable {
    let records: [EmployeeRecord]
}

struct EmployeeRecord: Decodable, Identifiable {
    let id: String
    let fields: EmployeeFields
}

struct EmployeeFields: Decodable {
    let EmployeeNumber: Int
    let name: String
    let password: String
    let job_title: String
}
