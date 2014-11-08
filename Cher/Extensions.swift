//
//  Extensions.swift
//  Cher
//
//  Created by Dzianis Lebedzeu on 11/8/14.
//  Copyright (c) 2014 CocoaHeadsBY. All rights reserved.
//

import Foundation

extension String {
    func queryToParams() -> [String: String] {
        var result: Dictionary<String, String> = self.componentsSeparatedByString("&").reduce([:], combine: {acc, value in
            let pair = value.componentsSeparatedByString("=")
            if pair.count != 2 {
                return acc
            }
            var result = acc
            result.updateValue(pair.last!, forKey: pair.first!)
            return result
        })
        return result
    }
}