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
    var updatedDataArray: ((_ newDataArray: [Feature]) -> ())!
    
    lazy var service: APIManager = {
        let service = APIManager()
        bindingService(service)
        return service
    }()
    
    private func bindingService(_ service: APIManager) {
        service.updatedLoadingStatus = { isLoading in
            if isLoading {
                
            }
            else {
                
            }
        }
        service.updatedDataArray = { [weak self] (newDataArray) in
            guard let strongSelf = self else { return }
            strongSelf.updatedDataArray(newDataArray)
        }
        
        service.receivedError = { (error) in
            
        }
    }
}
