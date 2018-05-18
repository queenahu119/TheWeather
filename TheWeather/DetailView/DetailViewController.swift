//
//  DetailViewController.swift
//  TheWeather
//
//  Created by QueenaHuang on 18/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()

        if let indexPath = indexPath,
            let data = viewModel?.getAllWeatherInfo(at: indexPath) {
            detailWeather = data
        }

        setupMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupMainView() {

        if let name = detailWeather?.name {
            cityLabel.text = "Now at \(name)"
        }

        if let main = detailWeather?.main {
            tempLabel.text = String(Int(main.temp ?? 0)) + " ℃"

            maxMinTempLabel.text = "\(Int(main.tempMin ?? 0)) ℃ | \(Int(main.tempMax ?? 0)) ℃"
        }

        if let weather = detailWeather?.weather.first {

            if let description = weather?.description {
                descriptionLabel.text = description
            } else {
                descriptionLabel.text = "None"
            }

            if let icon = weather?.icon {
                let imageUrl = weatherIconUrl + icon + ".png"

                weatherImageView.imageFromServerURL(urlString: imageUrl)
            }
        }

        cityLabel.font = UIFont.systemFont(ofSize: 20)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 35)
        maxMinTempLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
    }

}
