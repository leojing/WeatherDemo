//
//  WeatherDemoTests.swift
//  WeatherDemoTests
//
//  Created by JINGLUO on 3/3/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import XCTest
import RxSwift
import ObjectMapper
@testable import WeatherDemo

class WeatherDemoTests: XCTestCase {
    
    fileprivate let disposeBag = DisposeBag()
    var viewModel: WeatherCellViewModel?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApiClientSuccess() {
        viewModel = WeatherCellViewModel("2147714", MockAPIClient())
        
        viewModel?.cityName.asObservable()
            .subscribe(onNext: { name in
//                XCTAssertEqual(name, "Sydney")
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
        
//        viewModel?.title.asObservable()
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .subscribe(onNext: { title in
//                XCTAssertEqual(title, "About Canada")
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
//            .disposed(by: disposeBag)
//
//        viewModel?.listData.asObservable()
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .subscribe(onNext: { rows in
//                XCTAssertEqual(rows.first?.descriptionField, "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony")
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
//            .disposed(by: disposeBag)
    }
    
    func testApiClientEmpty() {
//        let mockApiClient = MockAPIClient()
//        mockApiClient.jsonFileName = .mockDataEmpty
//        viewModel = WeatherCellViewModel("2147714", mockApiClient)
        
//        viewModel?.title.asObservable()
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .subscribe(onNext: { title in
//                XCTAssertEqual(title, "About Canada")
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
//            .disposed(by: disposeBag)
//
//        viewModel?.listData.asObservable()
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .subscribe(onNext: { rows in
//                XCTAssertNil(rows.first)
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
//            .disposed(by: disposeBag)
    }
}


class MockAPIClient: APIClient {
    
    enum JsonFileName: String {
        case mockData = "MockDataSydney"
        case mockDataEmpty = "MockData_empty"
    }
    
    var jsonFileName = JsonFileName.mockData
    
    override func fetchWeatherInfo(_ config: APIConfig) -> Observable<RequestStatus> {
        return super.fetchWeatherInfo(config)
    }
    
    override func networkRequest(_ config: APIConfig, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void)) {
        guard let json = JsonFileLoader.loadJson(fileName: jsonFileName.rawValue) as? [String: Any] else {
            completionHandler(nil, RequestError("0", "Parse Content information failed."))
            return
        }
        
        completionHandler(json, nil)
    }
}

class JsonFileLoader {
    
    class func loadJson(fileName: String) -> Any? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    return try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        } else {
            print("invalid url")
        }
        
        return nil
    }
}
