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
    
    var isLoading: Bool = false {
        didSet{
            updatedLoadingStatus(isLoading)
        }
    }
    var dataArray: [Feature] = []
    var receivedError: ((Error) -> Void)!
    var updatedDataArray: ((_ newDataArray: [Feature]) -> ())!
    var updatedLoadingStatus: ((Bool) -> Void)!
}

extension APIManager {
    func fetchData() {
        guard !isLoading else {return}
        isLoading = true
        manager.request("https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json", method: .get).responseColdZ {[weak self] (dataResponse) in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
            DispatchQueue.global().async {
                let result = strongSelf.parseResult(dataResponse.result)
                DispatchQueue.main.async {
                    switch result {
                    case .success(let parsedData):
                        strongSelf.updatedDataArray(parsedData)
                    case .failure(let error):
                        strongSelf.receivedError(error)
                    }
                }
            }
        }
    }
    
    private func parseResult(_ result: Result<[String: Any]>) -> Result<[Feature]> {
        switch result {
        case .success(let rawData):
            var parsedArray: [Feature] = []
            do{
                parsedArray = try self.parseRawData(rawData)
            }
            catch{
                return .failure(error)
            }
            parsedArray = self.filterParsedData(parsedArray)
            self.dataArray.append(contentsOf: parsedArray)
            return .success(parsedArray)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func parseRawData(_ rawData: [String: Any]) throws -> [Feature] {
        guard let featureRawData = rawData["features"] as? [[String: Any]] else {
            throw NSError.jsonParseError
        }
        let parsedArray = featureRawData.compactMap({parseFeatureRawData($0)})
        
        return parsedArray
    }
    
    private func parseFeatureRawData(_ rawData: [String: Any]) -> Feature? {
        guard let feature = Feature(rawData: rawData) else { return nil }
        return feature
    }
    
    private func filterParsedData(_ parsedArray: [Feature]) -> [Feature]{
        let countyMaskCount = parsedArray.reduce(into: [:]) { (result, feature) in
            result[feature.countyName] = (result[feature.countyName] ?? 0 ) + feature.adultMaskCount
        }
        var featureArray: [Feature] = []
        for (countyName, adultMaskCount) in countyMaskCount {
            let feature = Feature(countyName: countyName, adultMaskCount: adultMaskCount)
            featureArray.append(feature)
        }
        return featureArray.sorted(by: { $0.adultMaskCount > $1.adultMaskCount })
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
