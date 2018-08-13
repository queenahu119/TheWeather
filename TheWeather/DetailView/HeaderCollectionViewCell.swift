//
//  HeaderCollectionViewCell.swift
//  TheWeather
//
//  Created by QueenaHuang on 10/8/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit
import SnapKit

let padding = UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20)

class BaseCollectionViewCell: UICollectionViewCell {

    var weather: WeatherData? {
        didSet {
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {

    }
}

class HeaderCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!

    override var weather: WeatherData? {
        didSet {
            if let name = weather?.name {
                cityLabel.text = "Now at \(name)"
            }

            if let main = weather?.main {
                tempLabel.text = String(Int(main.temp ?? 0)) + " ℃"
            }

            if let weatherInfo = weather?.weather.first {

                if let icon = weatherInfo?.icon {
                    let imageUrl = weatherIconUrl + icon + ".png"

                    weatherIcon.imageFromServerURL(urlString: imageUrl)
                }
            }
        }
    }

    override func setupUI() {
        cityLabel.font = UIFont.systemFont(ofSize: 20)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 35)

        cityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(padding.left)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(padding.top)
            make.right.equalTo(self.snp.right).offset(padding.right)
            make.height.equalTo(30)
        }
        tempLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(padding.right)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(100)
        }
        weatherIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(padding.left)
            make.top.equalTo(cityLabel.snp.bottom).offset(padding.top)
            make.size.equalTo(100)
        }
    }
}

class DetailCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var maxMinTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override var weather: WeatherData? {
        didSet {
            if let main = weather?.main {
                maxMinTempLabel.text = "\(Int(main.tempMin ?? 0)) ℃ | \(Int(main.tempMax ?? 0)) ℃"
            }

            if let weather = weather?.weather.first {
                if let description = weather?.description {
                    descriptionLabel.text = description
                } else {
                    descriptionLabel.text = "-"
                }
            }
        }
    }

    override func setupUI() {
        maxMinTempLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(padding.left)
            make.right.equalTo(self.snp.right).offset(padding.right)
            make.top.equalTo(self.snp.top).offset(padding.top)
            make.height.equalTo(30)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(padding.left)
            make.right.equalTo(self.snp.right).offset(padding.right)
            make.top.equalTo(maxMinTempLabel.snp.bottom).offset(padding.top)
            make.height.equalTo(30)
        }
    }
}

enum WeatherType {
    case humidity
    case pressure
    case wind
    case rain
}

class WeatherCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    var type: WeatherType?

    override var weather: WeatherData? {
        didSet {
            descriptionLabel.text = "-"

            if let type = type {
                switch type {
                case WeatherType.humidity:
                    if let main = weather?.main, let humidity = main.humidity {
                        descriptionLabel.text = "\(humidity) %"
                    }
                    weatherIcon.image = UIImage(named: "image_humidity")
                case WeatherType.pressure:
                    if let main = weather?.main, let pressure = main.pressure {
                        descriptionLabel.text = "\(pressure) hPa"
                    }
                    weatherIcon.image = UIImage(named: "image_pressure")
                case WeatherType.wind:
                    if let wind = weather?.wind {
                        let speed = wind.speed ?? 0
                        descriptionLabel.text = "\(speed) m/s"
                    }
                    weatherIcon.image = UIImage(named: "image_wind")
                case WeatherType.rain:
                    if let rain = weather?.rain {
                        let volume = rain.volume ?? 0
                        descriptionLabel.text = "\(volume) mm"
                    }
                    weatherIcon.image = UIImage(named: "image_rain")
                default: break
                }
            }
        }
    }

    override func setupUI() {
        let imageSize = 40
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)

        weatherIcon.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(padding.left)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(imageSize)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(weatherIcon.snp.right).offset(8)
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-8)
        }

//        descriptionLabel.backgroundColor = UIColor.blue
    }
}
