//
//  APIService.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import Alamofire
import Foundation

class APIService: SessionManager {
    private(set) var sessionManager: SessionManager
    private static var requestAdapter = APIRequestAdapter()

    var currentRequest: DataRequest? = nil
    
    init(_ configuration: URLSessionConfiguration = .default, useAccessToken: Bool = false) {
        sessionManager = SessionManager(configuration: configuration)
        super.init()
        if useAccessToken{
            sessionManager.adapter = APIService.requestAdapter
        }
    }
    
    static func setAccessToken(_ token: String?){
        APIService.requestAdapter.setAccessToken(token)
    }
    
    static func setAppVersion(_ version: String){
        APIService.requestAdapter.setAppVersion(version)
    }
    
    func applyTokenAdapter(){
        sessionManager.adapter = APIService.requestAdapter
    }
}
