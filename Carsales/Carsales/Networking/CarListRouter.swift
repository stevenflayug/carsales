//
//  CarListRouter.swift
//  Carsales
//
//  Created by Steven Layug on 1/11/21.
//

import Foundation
import UIKit
import Moya

class CarListRouter {
    let provider = MoyaProvider<UserRequest>(plugins: [NetworkLoggerPlugin()])
    
    public func startCarListRequest(completion: @escaping (_ carList: CarData?, _ error: String?) -> Void) {
        provider.request(.carList) { result in
            switch result {
            case .success(let response):
                do {
                    print(try response.mapJSON())
                    if let results = try? response.map(CarData.self) {
                        print(results)
                        completion(results, nil)
                    }
                } catch let error {
                    print(error)
                    completion(nil, "No Car List Retrieved")
                    return
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
                return
            }
        }
    }
    
    public func startCarDetailsRequest(options: CarDetailsOptions, completion: @escaping (_ CarDetails: CarDetails?, _ error: String?) -> Void) {
        provider.request(.carDetails(options: options)) { result in
            switch result {
            case .success(let response):
                do {
                    print(try response.mapJSON())
                    if let results = try? response.map(CarDetails.self) {
                        print(results)
                        completion(results, nil)
                    }
                } catch let error {
                    print(error)
                    completion(nil, "No Car List retrieved")
                    return
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
                return
            }
        }
    }
}
