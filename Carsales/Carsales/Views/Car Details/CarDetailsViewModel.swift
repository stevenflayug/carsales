//
//  CarDetailsViewModel.swift
//  Carsales
//
//  Created by Steven Layug on 31/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class CarDetailsViewModel {
    private let router = CarListRouter()
    private var detailsUrl = ""
    
    let reviewsServiceDone: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let carDetails: BehaviorRelay<CarDetails> = BehaviorRelay(value: CarDetails())
    let detailImages: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    let disposeBag = DisposeBag()
    
    init(detailsUrl: String) {
        self.detailsUrl = detailsUrl
    }
    
    func startCarDetailsRequest() {
        self.router.startCarDetailsRequest(options: CarDetailsOptions(detailsUrl: self.detailsUrl)) { [weak self] (data, error) in
            guard let _self = self else { return }
            guard data != nil else {
                _self.errorMessage.accept(error ?? "")
                return
            }
            _self.detailImages.accept(data?.overview.photos ?? [])
            _self.carDetails.accept(data ?? CarDetails())
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

