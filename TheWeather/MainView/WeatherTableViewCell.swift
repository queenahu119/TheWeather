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
                let formatString = temperature.format(".1")
                temperatureLabel.text = "\(formatString) ℃"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        cityLabel.font = UIFont.systemFont(ofSize: 20)
        temperatureLabel.font = UIFont.systemFont(ofSize: 28)
        temperatureLabel.textAlignment = .right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
