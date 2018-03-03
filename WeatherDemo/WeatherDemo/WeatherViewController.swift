//
//  ViewController.swift
//  WeatherDemo
//
//  Created by JINGLUO on 3/3/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UITableViewController {

    enum SegueIdentifiers {
        static let showWeatherDetail = "showDetail"
    }
    private let defaultCityList = ["4163971", "2147714", "2174003"]

    fileprivate let disposeBag = DisposeBag()
    var viewModel: WeatherListViewModel? {
        didSet {
            setupViewModelBinds()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel = WeatherListViewModel(defaultCityList)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.showWeatherDetail,
            let destination = segue.destination as? WeatherDetailViewController {
            let vm = sender as? WeatherCellViewModel
            destination.viewModel = vm
        }
    }
    
    fileprivate func setupUI() {
        let refreshButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshAction))
        navigationItem.rightBarButtonItem = refreshButtonItem
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let cell = self.tableView.cellForRow(at: indexPath) as! WeatherTableViewCell
                let viewModel = cell.viewModel
                self.performSegue(withIdentifier: SegueIdentifiers.showWeatherDetail, sender: viewModel)
            }).disposed(by: disposeBag)
    }
    
    fileprivate func setupViewModelBinds() {
        
        // load tableview cells
        tableView.dataSource = nil
        viewModel?.citiesData.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: WeatherTableViewCell.reuseId(), cellType: WeatherTableViewCell.self)) { (row, element, cell) in
//                NSLog("current thread: %@, in file: %@, function: %@", Thread.current, #file, #function)
                cell.configureCell(element, showAlert: { message in
                    self.showAlert(message)
                })
            }
            .disposed(by: disposeBag)
        
        // show error message
        viewModel?.alertMessage.asObservable()
            .subscribe(onNext: { errorMessage in
                self.showAlert(errorMessage)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    // MARK: Actions
    @objc fileprivate func refreshAction() {
        viewModel?.refreshData()
    }
    
    fileprivate func showAlert( _ message: String?) {
        guard let message = message else {
            return
        }
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

