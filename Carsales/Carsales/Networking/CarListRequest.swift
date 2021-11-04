//
//  CarListRequest.swift
//  Carsales
//
//  Created by Steven Layug on 1/11/21.
//

import Foundation
import Moya

public enum UserRequest {
    case carList
    case carDetails(options: CarDetailsOptions)
}

extension UserRequest: TargetType {
    public var baseURL: URL {
        return URL(string: "https://www.mocky.io")!
    }
    
    public var path: String {
        switch self {
        case .carList: return "/v3/e8c52b55-7f44-41a8-b059-5d042269b520"
        case .carDetails(let options): return "\(options.detailsUrl)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return .requestParameters(parameters: [:],
                                  encoding: URLEncoding.default)
    }
    
    public var headers: [String: String]? {
        return [:]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}

