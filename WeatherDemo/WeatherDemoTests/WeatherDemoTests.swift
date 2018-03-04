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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApiClientSuccess() {
        MockAPIClient().fetchWeatherInfo(APIConfig.weather(id: "2147714"))
            .asObservable()
            .subscribe(onNext: { status in
                switch status {
                case .success(let w):
                    let weather = w as? Weather
                    XCTAssertEqual(weather?.name, "Sydney")
                    XCTAssertEqual(weather?.main?.temp, 298.15)
                    XCTAssertEqual(weather?.wind?.speed, 7.7)
                    XCTAssertEqual(weather?.sys?.sunrise, 1520019878)

                case .fail(let error):
                    print(error.localizedDescription)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
    }
    
    func testApiClientEmpty() {
        let apiClient = MockAPIClient()
        apiClient.jsonFileName = .mockDataEmpty
        apiClient.fetchWeatherInfo(APIConfig.weather(id: "2147714"))
        .asObservable()
            .subscribe(onNext: { status in
                switch status {
                case .success(let w):
                    let weather = w as? Weather
                    XCTAssertEqual(weather?.name, "Sydney")
                    XCTAssertNil(weather?.weatherDetail)
                    XCTAssertNil(weather?.main)
                    XCTAssertNil(weather?.sys)
                    
                case .fail(let error):
                    print(error.localizedDescription)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        .disposed(by: disposeBag)
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
