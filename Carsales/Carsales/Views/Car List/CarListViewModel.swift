//
//  CarListViewModel.swift
//  Carsales
//
//  Created by Steven Layug on 31/10/21.
//

import Foundation
import RxSwift
import RxCocoa

class CarListViewModel {
    private let router = CarListRouter()
    
    let searchTextValue: BehaviorRelay<String> = BehaviorRelay(value: "")
    let carList: BehaviorRelay<[Car]> = BehaviorRelay(value: [])
    let errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    
    func startCarListRequest() {
        self.router.startCarListRequest { [weak self] (data, error) in
            guard let _self = self else { return }
            guard data != nil else {
                _self.errorMessage.accept(error ?? "")
                return
            }
            _self.carList.accept(data?.car ?? [])
        }
    }
}

