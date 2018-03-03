//
//  WeatherListViewModel.swift
//  WeatherDemo
//
//  Created by JINGLUO on 3/3/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class WeatherListViewModel {
    
    fileprivate enum AlertMessages {
        static let emptyList = "City list is empty"
    }

    private var citiesList: [String]?

    let disposeBag = DisposeBag()
    
    var citiesData = Variable<[String]>([])
    var alertMessage = BehaviorRelay<String?>(value: nil)

    init(_ cityList: [String]?) {
        citiesList = cityList
        bindCitiesInfo(citiesList)
    }
    
    init(_ apiService: APIService?) {
    }

    fileprivate func bindCitiesInfo(_ cityList: [String]?) {
        guard let cityList = cityList else {
            self.alertMessage.accept(AlertMessages.emptyList)
            return
        }
        
        citiesData.value = cityList
    }
    
    func refreshData() {
        bindCitiesInfo(citiesList)
    }
}

