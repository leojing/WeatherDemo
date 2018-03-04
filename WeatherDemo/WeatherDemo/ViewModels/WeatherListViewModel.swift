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

    // MARK: init with city id list and APIService
    init(_ cityList: [String]?) {
        citiesList = cityList
        fetchCitiesInfo(citiesList)
    }
    
    // MARK: init with APIService
    init(_ apiService: APIService?) {
        fatalError("Not implement")
    }

    // MARK: fetch citiesData by passing cityList, because we don't have to get date from remote. So we just did a simple assignment.
    // In the future if needed, we can fetch data from remote by APIService.
    fileprivate func fetchCitiesInfo(_ cityList: [String]?) {
        guard let cityList = cityList else {
            self.alertMessage.accept(AlertMessages.emptyList)
            return
        }
        
        citiesData.value = cityList
    }
    
    // MARK: refetch data
    func refreshData() {
        fetchCitiesInfo(citiesList)
    }
}

