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
    let maskAdultCount: Int
    
    init?(rawData: Any){
        guard let rawData = rawData as? [String: Any] else { return nil }
        guard let featureData = rawData["properties"] as? [String: Any] else { return nil }
        guard let countyName = featureData["county"] as? String,
            let maskAdultCount = featureData["mask_adult"] as? Int else { return nil }
        self.countyName = countyName
        self.maskAdultCount = maskAdultCount
    }
}
