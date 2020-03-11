//
//  APIManager.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import Alamofire

class APIManager {
    typealias Completion = ((Result<[String: Any]>) -> ())
    
    static let shared: APIManager = APIManager()
    
    let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        let manager = SessionManager(configuration: configuration)
        manager.adapter = APIRequestAdapter()
        return manager
    }()
    
    private var requestAdapter: APIRequestAdapter {
        return manager.adapter as! APIRequestAdapter
    }
}

extension APIManager{
    func fetchData(completion: @escaping Completion) {
        manager.request("https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json", method: .get).responseColdZ { (response) in
            DispatchQueue.main.async {
                completion(response.result)
            }
        }
    }
}

class APIRequestAdapter: RequestAdapter {
    fileprivate var accessToken: String? = nil
    fileprivate var additionalHeaderInfo: [String: String] = ["X-App-Version" : "1.0.0",
                                                              "X-Platform" : "ios"]
    var withoutTokenURLs: [String] = []
    
    
    init(accessToken: String? = nil) {
        self.accessToken = accessToken
    }
    func setAccessToken(_ token: String?){
        accessToken = token
    }
    func setAppVersion(_ version: String){
        additionalHeaderInfo["X-App-Version"] = version
    }
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        for (key, value) in additionalHeaderInfo {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let token = accessToken, let urlString = urlRequest.url?.absoluteString, !withoutTokenURLs.contains(urlString) {
            urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        //print("Request:", urlRequest.url!.absoluteString)
        return urlRequest
    }
}
