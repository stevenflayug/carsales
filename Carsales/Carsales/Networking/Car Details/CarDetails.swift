//
//  CarDetails.swift
//  Carsales
//
//  Created by Steven Layug on 1/11/21.
//

import Foundation

struct CarDetails: Codable {
    let id, saleStatus, title: String
    let overview: Overview
    let comments: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case saleStatus = "SaleStatus"
        case title = "Title"
        case overview = "Overview"
        case comments = "Comments"
    }
    
    init() {
        self.id = ""
        self.saleStatus = ""
        self.title = ""
        self.overview = Overview()
        self.comments = ""
    }
}

struct Overview: Codable {
    let location: String
    let price: String?
    let photos: [String]
    
    enum CodingKeys: String, CodingKey {
        case location = "Location"
        case price = "Price"
        case photos = "Photos"
    }
    
    init() {
        self.location = ""
        self.price = ""
        self.photos = []
    }
}
