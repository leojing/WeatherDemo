//
//  APIService.swift
//  WeatherDemo
//
//  Created by JINGLUO on 3/3/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

// MARK: - RequestStatus definition
enum RequestStatus {
    case success(Any)
    case fail(RequestError)
}

// MARK: - RequestError definition
struct RequestError : LocalizedError {
    
    var statusCode: String? { return sCode }
    var errorDescription: String? { return mMsg }
    var failureReason: String? { return mMsg }
    var recoverySuggestion: String? { return "" }
    var helpAnchor: String? { return "" }
    
    private var sCode : String
    private var mMsg : String
    
    init(_ code: String, _ description: String) {
        sCode = code
        mMsg = description
    }
}

// MARK: - APIConfig definition
enum APIConfig  {
    case weather(id: String)
}

extension APIConfig {
    
    static let API_KEY = "59dfd15b2c803e313d19d07be10aa6ac"

    var baseURL: String {
        switch self {
        case .weather(_):
            return "http://api.openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .weather(_):
            return "/data/2.5/weather?"
        }
    }
    
    var method: String {
        switch self {
        case .weather(_):
            return "GET"
        }
    }
    
    var header: [String: Any]?{
        switch self {
        case .weather(_):
            return nil
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .weather(let id):
            return ["id": id, "appid": APIConfig.API_KEY, "units": "metric"]
        }
    }
    
    func getFullURLStr() -> String {
        switch self {
        case .weather(_):
            if let parameters =  self.parameters{
                let parameter = parameters.keys.map { key in
                    return "\(key)=\(parameters[key] ?? "")"
                }
                let paraString = parameter.joined(separator: "&")
                return baseURL + path + paraString
            }
            return baseURL + path
        }
    }
}

// MARK: - APIService protocol definition
protocol APIService {
    func fetchWeatherInfo(_ config: APIConfig) -> Observable<RequestStatus>
    func networkRequest(_ config: APIConfig, completionHandler: @escaping ((_ jsonResponse: [String: Any]?, _ error: RequestError?) -> Void))
}

