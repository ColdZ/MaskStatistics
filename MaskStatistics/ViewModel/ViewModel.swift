//
//  ViewModel.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import Alamofire
import UIKit

class ViewModel: NSObject {
    lazy var service: APIManager = {
        let service = APIManager()
        bindingService(service)
        return service
    }()

    func getData(_ completion: @escaping (Result<Any>) -> Void) {
        service.fetchData()
    }
    
    private func bindingService(_ service: APIManager) {
        service.updatedLoadingStatus = { isLoading in
            if isLoading {
                
            }
            else {
                
            }
        }
        service.updatedDataArray = { [weak self] (newDataArray) in
            let countyMaskCount = newDataArray.reduce(into: [:]) { (result, feature) in
                result[feature.countyName] = (result[feature.countyName] ?? 0 ) + feature.adultMaskCount
            }
            print("countyMaskCount:\(countyMaskCount)")
        }
        service.receivedError = { (error) in
        }
    }
}
