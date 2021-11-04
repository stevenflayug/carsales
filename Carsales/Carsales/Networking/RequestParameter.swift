//
//  RequestParameter.swift
//  Carsales
//
//  Created by Steven Layug on 1/11/21.
//

import Foundation

protocol RequestParameter {
    var urlParameters: [String: Any] { get }
    var bodyParameters: [String: Any] { get }
}

extension RequestParameter {
    var urlParameters: [String: Any] {
        return [String: Any]()
    }
    
    var bodyParameters: [String: Any] {
        return [String: String]()
    }
}
