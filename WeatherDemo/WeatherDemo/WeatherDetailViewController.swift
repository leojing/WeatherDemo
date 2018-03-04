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
import Kingfisher

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
    var viewModel: WeatherDetailViewModel?
    
    // MARK: override func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherDetailViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        setupViewModelBinds()
        // set weather icon imageview animated
        animationForIconView(iconImageView)
    }
    
    // MARK: Bind ViewModel
    fileprivate func setupViewModelBinds() {
        // update navigation bar title
        viewModel?.cityName.asObservable()
            .filter{ $0 != nil }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { title in
                self.title = title
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        
        // bind weather to detail UI elements
        viewModel?.weather.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { weather in
                self.updateUI(weather)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    // MARK: update UI elements
    fileprivate func updateUI(_ weather: Weather?) {
        self.tempLabel.text = self.tranformTemp(weather?.main?.temp)
        self.summeryLabel.text = weather?.weatherDetail?.first?.descriptionField
        let imageUrl = URL(string: "http://openweathermap.org/img/w/\(weather?.weatherDetail?.first?.icon ?? "").png")
        self.iconImageView.kf.setImage(with: imageUrl)
        
        self.minTempLabel.text = "Min: \(self.tranformTemp(weather?.main?.tempMin))"
        self.maxTempLabel.text = "Max: \(self.tranformTemp(weather?.main?.tempMax))"
        
        self.sunriseLabel.text = "Sunrise: \(self.transformTime(weather?.sys?.sunrise) ?? "Unknow")"
        self.sunsetLabel.text = "Sunset: \(self.transformTime(weather?.sys?.sunset) ?? "Unknow")"
        
        self.windLabel.text = "Wind: \(String(describing: weather?.wind?.speed ?? 0))km/h"
        self.humidityLabel.text = "Humidity: \(String(describing: weather?.main?.humidity ?? 0))%"
    }
    
    // MARK: Actions
    fileprivate func animationForIconView(_ icon: UIImageView) {
        UIView.animate(withDuration: 1, animations: {
            icon.frame.size.width += 10
            icon.frame.size.height += 10
        }, completion: { _ in
            UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse], animations: {
                icon.frame.origin.x -= 10
            }, completion: nil)
        })
    }

    @objc fileprivate func rotated() {
        animationForIconView(iconImageView)
    }

}

extension WeatherDetailViewController {
    
    fileprivate func tranformTemp(_ temp: Float?) -> String {
        return "\(Int(temp ?? 0))℃"
    }
    
    fileprivate func transformTime(_ time: Int?) -> String? {
        let date = Date(timeIntervalSince1970: Double(time ?? 0))
        return date.timeOfHour()
    }
}
