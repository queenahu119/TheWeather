//
//  WeatherTableViewCell.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    var weather: WeatherCellViewModel? {
        didSet {
            cityLabel.text = weather?.cityText

            if let temperature = weather?.temperatureText {
                let attribute = [ NSAttributedStringKey.foregroundColor: UIColor.red,
                                  NSAttributedStringKey.font: UIFont.systemFont(ofSize: 28)]
                let formatString = temperature.format(".1")
                let attrString = NSMutableAttributedString(string: "$\(formatString) ", attributes: attribute)

                temperatureLabel.attributedText = attrString
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
