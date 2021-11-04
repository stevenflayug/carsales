//
//  Car.swift
//  Carsales
//
//  Created by Steven Layug on 1/11/21.
//

import Foundation

struct CarData: Codable {
    let car: [Car]

    enum CodingKeys: String, CodingKey {
        case car = "Result"
    }
}

struct Car: Codable {
    let id, title: String
    let location: String?
    let price: String?
    let mainPhoto: String
    let detailsURL: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case title = "Title"
        case location = "Location"
        case price = "Price"
        case mainPhoto = "MainPhoto"
        case detailsURL = "DetailsUrl"
    }
}
