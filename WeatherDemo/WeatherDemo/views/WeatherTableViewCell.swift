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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    static func reuseId() -> String {
        return String(describing: self)
    }
    
    func configureCell(_ cityId: String?, showAlert alertHandler: ShowAlertHandler?) {
        guard let cityId = cityId else {
            return
        }
        
        if let alertHandler = alertHandler {
            showAlertHandler = alertHandler
        }
        
        viewModel = WeatherDetailViewModel(cityId, APIClient())
    }
    
    fileprivate func setupViewModelBinds() {
        viewModel?.cityName.asObservable()
            .filter{ $0 != nil }
            .observeOn(MainScheduler.instance)
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.temperature.asObservable()
            .filter{ $0 != nil }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { temp in
                NSLog("current thread: %@, in file: %@, function: %@", Thread.current, #file, #function)
                self.tempLabel.text = "\(Int(temp!))℃"
                self.contentView.layoutSubviews()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
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
