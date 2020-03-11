//
//  Date+ColdZ.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import UIKit

extension Date {
    func toString(dateFormat:String = "HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let dateString = formatter.string(from: self)
        return dateString
    }
}
