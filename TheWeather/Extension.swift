//
//  Extension.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import Foundation

extension Double {
    func format(_ formatString: String) -> String {
        return String(format: "%\(formatString)f", self)
    }
}
