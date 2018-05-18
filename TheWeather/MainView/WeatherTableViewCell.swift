//
//  WeatherTableViewCell.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit
import SnapKit

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

        setupUI()

        cityLabel.font = UIFont.systemFont(ofSize: 20)
        temperatureLabel.font = UIFont.systemFont(ofSize: 28)
        temperatureLabel.textAlignment = .right
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupUI() {
        let padding = UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20)

        cityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(padding.left)
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(temperatureLabel.snp.left)
            make.height.equalTo(50)
        }

        temperatureLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(padding.right)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }

}
