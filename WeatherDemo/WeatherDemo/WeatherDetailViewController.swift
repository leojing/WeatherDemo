//
//  WeatherDetailViewController.swift
//  WeatherDemo
//
//  Created by JINGLUO on 3/3/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var summeryLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    fileprivate var disposeBag = DisposeBag()
    var viewModel: WeatherCellViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModelBinds()
    }
    
    fileprivate func setupViewModelBinds() {
        viewModel?.cityName.asObservable()
            .filter{ $0 != nil }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { title in
                self.title = title
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        
        viewModel?.weather.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { weather in
                self.tempLabel.text = self.tranformTemp(weather?.main?.temp)
                self.minTempLabel.text = "Min \(self.tranformTemp(weather?.main?.tempMin))"
                self.maxTempLabel.text = "Max \(self.tranformTemp(weather?.main?.tempMax))"
                
                self.sunriseLabel.text = "sunrise \(self.transformTime(weather?.sys?.sunrise) ?? "Unknow")"
                self.sunsetLabel.text = "sunset \(self.transformTime(weather?.sys?.sunset) ?? "Unknow")"

                self.summeryLabel.text = weather?.weatherDetail?.first?.descriptionField
                self.windLabel.text = "\(String(describing: weather?.wind?.speed ?? 0))"
                self.humidityLabel.text = "\(String(describing: weather?.main?.humidity ?? 0))"
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }

}

extension WeatherDetailViewController {
    
    fileprivate func tranformTemp(_ temp: Float?) -> String {
        return "\(temp ?? 0)℉"
    }
    
    fileprivate func transformTime(_ time: Int?) -> String? {
        let date = Date(timeIntervalSince1970: Double(time ?? 0))
        return date.timeOfHour()
    }
}
