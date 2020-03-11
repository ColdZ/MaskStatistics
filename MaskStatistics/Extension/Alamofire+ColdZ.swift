//
//  Alamofire+ColdZ.swift
//  MaskStatistics
//
//  Created by ColdZ on 2020/3/11.
//  Copyright © 2020 ColdZ. All rights reserved.
//

import Alamofire

extension DataRequest {
    static func responseSerializer() -> DataResponseSerializer<[String: Any]> {
        return DataResponseSerializer { request, response, data, error in
            let result = Request.serializeResponseJSON(options: .allowFragments, response: response, data: data, error: error)
            switch result {
            case .success(let data):
                if let data = data as? [String: Any],
                    let type = data["type"] as? String,
                    type == "FeatureCollection" {
                        return Result.success(data)
                } else {
                    print("Request failure:", request?.url ?? "nil")
                    print("JSON Parse error:", data)
                    return Result.failure(NSError.jsonParseError)
                }
            case .failure(let error):
                switch error._code{
                case -1009:
                    let cError = NSError(domain: error._domain, code: error._code, userInfo: [NSLocalizedDescriptionKey : "網路連線異常，請重新再試"])
                    return Result.failure(cError)
                default:
                    return Result.failure(error)
                }
            }
        }
    }
    
    @discardableResult func responseColdZ(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[String: Any]>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.responseSerializer(),
            completionHandler: completionHandler
        )
    }
}
