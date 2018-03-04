//
//  WeatherCellViewModel.swift
//  WeatherDemo
//
//  Created by JINGLUO on 3/3/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class WeatherDetailViewModel {
    
    fileprivate enum AlertMessages {
        static let emptyAPIService = "Must init an APIService"
    }

    let disposeBag = DisposeBag()
    private let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    private var networkService: APIService?
    private var cityID: String = ""

    var weather = BehaviorRelay<Weather?>(value: nil)
    var cityName = BehaviorRelay<String?>(value: nil)
    var temperature = BehaviorRelay<Float?>(value: nil)
    var isProgress = BehaviorRelay<Bool>(value: true)
    var alertMessage = BehaviorRelay<String?>(value: nil)

    // MARK: init with city id and APIService
    init(_ cityId: String, _ apiService: APIService?) {
        bindWeatherData()
        
        cityID = cityId
        networkService = apiService
        fetchWeatherInfo(apiService)
    }
    
    // MARK: fetch Weather info from remote server
    fileprivate func fetchWeatherInfo(_ apiService: APIService?) {
        guard let service = apiService else {
            fatalError(AlertMessages.emptyAPIService)
        }
        
        // activity indicator start animation
        isProgress.accept(true)
        
        let apiConfig = APIConfig.weather(id: cityID)
        service.fetchWeatherInfo(apiConfig)
            .observeOn(concurrentScheduler)
            .subscribe(onNext: { status in
                NSLog("current thread: %@, in file: %@, function: %@", Thread.current, #file, #function)

                // activity indicator start animation
                self.isProgress.accept(false)
                
                switch status {
                case .success(let w):
                    self.weather.accept(w as? Weather)

                case .fail(let error):
                    let errorMessage = error.errorDescription ?? "Faild to load remote data."
                    self.alertMessage.accept(errorMessage)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    // MARK: bind weather with cityName and temperature, make sure when weather value changes, can get new cityName and temperature value
    fileprivate func bindWeatherData() {
        weather.asObservable()
            .observeOn(concurrentScheduler)
            .subscribe(onNext: { weather in
                NSLog("current thread: %@, in file: %@, function: %@", Thread.current, #file, #function)

                self.cityName.accept(weather?.name)
                self.temperature.accept(weather?.main?.temp)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }
}
