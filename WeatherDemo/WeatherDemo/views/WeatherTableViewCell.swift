//
//  WeatherTableViewCell.swift
//  WeatherDemo
//
//  Created by JINGLUO on 3/3/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WeatherTableViewCell: UITableViewCell {
    
    typealias ShowAlertHandler = (String?)->Void
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    fileprivate var disposeBag = DisposeBag()
    var viewModel: WeatherDetailViewModel? {
        didSet {
            setupViewModelBinds()
        }
    }

    fileprivate var showAlertHandler: ShowAlertHandler?
    
    // MARK: override and basic static func
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // To avoid multiple outdated subscriptions, we need to create new DisposeBag for each cell reuse
        disposeBag = DisposeBag()
    }
    
    static func reuseId() -> String {
        return String(describing: self)
    }
    
    // MARK: configureCell with cityId, initial WeatherDetailViewModel with cityId to get remote detail data
    func configureCell(_ cityId: String?, showAlert alertHandler: ShowAlertHandler?) {
        guard let cityId = cityId else {
            return
        }
        
        // showAlertHandler is assign "show alert view" method to ViewController
        if let alertHandler = alertHandler {
            showAlertHandler = alertHandler
        }
        
        // init viewModel
        viewModel = WeatherDetailViewModel(cityId, APIClient())
    }
    
    // MARK: set up ViewModel binds
    fileprivate func setupViewModelBinds() {
        // update city name
        viewModel?.cityName.asObservable()
            .filter{ $0 != nil }
            .observeOn(MainScheduler.instance)
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        // update temperature
        viewModel?.temperature.asObservable()
            .filter{ $0 != nil }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { temp in
                NSLog("current thread: %@, in file: %@, function: %@", Thread.current, #file, #function)
                self.tempLabel.text = "\(Int(temp!))℃"
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        // update isProgress status to make the activity indicator spin or not
        viewModel?.isProgress
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isprogress in
                isprogress ? self.spinnerView.startAnimating() : self.spinnerView.stopAnimating()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        
        // show error message
        viewModel?.alertMessage.asObservable()
            .filter{$0 != nil}
            .subscribe(onNext: { errorMessage in
                if let handler = self.showAlertHandler {
                    handler(errorMessage!)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
