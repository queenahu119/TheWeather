//
//  DetailViewController.swift
//  TheWeather
//
//  Created by QueenaHuang on 18/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit
import SnapKit

let weatherIconUrl = "https://openweathermap.org/img/w/"

class DetailViewController: UIViewController {

    var cityName: String?
    var indexPath: IndexPath?
    var viewModel: MainViewModel?

    fileprivate var detailWeather: WeatherData?

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityImageView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainImageView: UIImageView!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var pressureImageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let indexPath = indexPath,
            let data = viewModel?.getAllWeatherInfo(at: indexPath) {
            detailWeather = data
        }

        view.backgroundColor = UIColor.cyan
        mainView.backgroundColor = UIColor.cyan
        detailView.backgroundColor = UIColor.cyan
        
        setupUI()
        setupDetailViewUI()

        updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateData() {

        if let name = detailWeather?.name {
            cityLabel.text = "Now at \(name)"
        }

        if let main = detailWeather?.main {
            tempLabel.text = String(Int(main.temp ?? 0)) + " ℃"

            maxMinTempLabel.text = "\(Int(main.tempMin ?? 0)) ℃ | \(Int(main.tempMax ?? 0)) ℃"

            if let humidity = main.humidity {
                humidityLabel.text = "\(humidity) %"
            }

            if let pressure = main.pressure {
                pressureLabel.text = "\(pressure) hPa"
            }
        }

        if let weather = detailWeather?.weather.first {

            if let description = weather?.description {
                descriptionLabel.text = description
            } else {
                descriptionLabel.text = "-"
            }

            if let icon = weather?.icon {
                let imageUrl = weatherIconUrl + icon + ".png"

                weatherImageView.imageFromServerURL(urlString: imageUrl)
            }
        }

        if let wind = detailWeather?.wind {
            let speed = wind.speed ?? 0
            windLabel.text = "\(speed) m/s"
        }

        if let rain = detailWeather?.rain {
            let volume = rain.volume ?? 0
            rainLabel.text = "\(volume) mm"
        }
    }

    let padding = UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20)

    func setupUI() {
        cityLabel.font = UIFont.systemFont(ofSize: 20)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 35)
        maxMinTempLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)

        cityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(padding.left)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(padding.top)
            make.right.equalTo(view.snp.right).offset(padding.right)
            make.height.equalTo(30)
        }

        mainView.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.top.equalTo(cityLabel.snp.bottom)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(228)
        }

        tempLabel.snp.makeConstraints { (make) in
            make.right.equalTo(mainView.snp.right).offset(padding.right)
            make.top.equalTo(mainView.snp.top).offset(20)
            make.size.equalTo(100)
        }
        weatherImageView.snp.makeConstraints { (make) in
            make.left.equalTo(mainView.snp.left).offset(padding.left)
            make.top.equalTo(mainView.snp.top).offset(padding.top)
            make.size.equalTo(100)
        }

        maxMinTempLabel.snp.makeConstraints { (make) in
            make.left.equalTo(mainView.snp.left).offset(padding.left)
            make.right.equalTo(mainView.snp.right).offset(padding.right)
            make.top.equalTo(weatherImageView.snp.bottom).offset(padding.top)
            make.height.equalTo(30)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(mainView.snp.left).offset(padding.left)
            make.right.equalTo(mainView.snp.right).offset(padding.right)
            make.top.equalTo(maxMinTempLabel.snp.bottom).offset(8)
            make.height.equalTo(30)
        }
    }

    func setupDetailViewUI() {
        let imageSize = 50

        windLabel.font = UIFont.systemFont(ofSize: 17)
        rainLabel.font = UIFont.systemFont(ofSize: 17)
        humidityLabel.font = UIFont.systemFont(ofSize: 17)
        pressureLabel.font = UIFont.systemFont(ofSize: 17)

        detailView.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.top.equalTo(mainView.snp.bottom)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(160)
        }

        windImageView.snp.makeConstraints { (make) in
            make.left.equalTo(detailView.snp.left).offset(padding.left)
            make.top.equalTo(detailView.snp.top).offset(padding.top)
            make.size.equalTo(imageSize)
        }

        rainImageView.snp.makeConstraints { (make) in
            make.left.equalTo(detailView.snp.left).offset(padding.left)
            make.top.equalTo(windImageView.snp.bottom).offset(padding.top)
            make.size.equalTo(imageSize)
        }

        humidityImageView.snp.makeConstraints { (make) in
            make.right.equalTo(humidityLabel.snp.left).offset(-8)
            make.top.equalTo(detailView.snp.top).offset(padding.top)
            make.size.equalTo(imageSize)
        }

        pressureImageView.snp.makeConstraints { (make) in
            make.left.equalTo(humidityImageView.snp.left)
            make.top.equalTo(humidityImageView.snp.bottom).offset(padding.top)
            make.size.equalTo(imageSize)
        }

        windLabel.snp.makeConstraints { (make) in
            make.left.equalTo(windImageView.snp.right).offset(8)
            make.top.equalTo(windImageView.snp.top)
            make.bottom.equalTo(windImageView.snp.bottom)
            make.right.equalTo(humidityImageView.snp.left).offset(8)
        }

        rainLabel.snp.makeConstraints { (make) in
            make.left.equalTo(windLabel.snp.left)
            make.top.equalTo(rainImageView.snp.top)
            make.bottom.equalTo(rainImageView.snp.bottom)
            make.right.equalTo(windLabel.snp.right)
        }

        humidityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(humidityImageView.snp.right).offset(8)
            make.top.equalTo(humidityImageView.snp.top)
            make.bottom.equalTo(humidityImageView.snp.bottom)
            make.right.equalTo(detailView.snp.right).offset(padding.right)
            make.width.equalTo(80).priority(.high)
        }

        pressureLabel.snp.makeConstraints { (make) in
            make.left.equalTo(humidityLabel.snp.left)
            make.top.equalTo(pressureImageView.snp.top)
            make.bottom.equalTo(pressureImageView.snp.bottom)
            make.right.equalTo(humidityLabel.snp.right)
            make.width.equalTo(80).priority(.high)
        }
    }
}
