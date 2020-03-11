//
//  Feature.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import UIKit

struct Feature {
    let countyName: String
    let adultMaskCount: Int
    
    init?(rawData: Any){
        guard let rawData = rawData as? [String: Any] else { return nil }
        guard let featureData = rawData["properties"] as? [String: Any] else { return nil }
        guard let countyName = featureData["county"] as? String,
            let adultMaskCount = featureData["mask_adult"] as? Int else { return nil }
        self.countyName = countyName
        self.adultMaskCount = adultMaskCount
    }
    
    init(countyName: String, adultMaskCount:Int) {
        self.countyName = countyName.count > 0 ? countyName : "未填寫的縣市"
        self.adultMaskCount = adultMaskCount
    }
}
