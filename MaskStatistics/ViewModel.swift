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
    func getData(_ completion: @escaping (Result<Any>) -> Void) {
        APIManager.shared.fetchData { (result) in
            switch result{
            case .success(let rawData):
                print("rawData:\(rawData["features"])")
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
