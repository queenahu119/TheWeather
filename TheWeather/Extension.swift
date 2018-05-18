//
//  Extension.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension UIImageView {
    func imageFromServerURL(urlString: String) {

        Alamofire.request(urlString).responseImage { response in

            if let image = response.result.value {
                self.image = image
            }
        }
    }
}

extension Double {
    func format(_ formatString: String) -> String {
        return String(format: "%\(formatString)f", self)
    }
}
