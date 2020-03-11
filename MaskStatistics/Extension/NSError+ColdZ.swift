//
//  NSError+ColdZ.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import Foundation

extension NSError {
    static var jsonParseError: NSError {
        return NSError(domain: "com.ColdZ.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON解析失敗"])
    }
    
    static var generalError: NSError {
        return NSError(domain: "com.ColdZ.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "哎呀...出了一點小問題，請稍後再試"])
    }
}
