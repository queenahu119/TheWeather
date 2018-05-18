//
//  MainViewModel.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import Foundation

class MainViewModel: NSObject {

    fileprivate let dataHelper : DataHelper

    init(dataHelper: DataHelper = DataHelper()) {
        self.dataHelper = dataHelper
    }

    var citys = ["2147714", "7839805", "2174003"]

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    // MARK: - callback
    var reloadTableViewClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?

    func initFetch() {
        fetchData()
    }

    var numberOfCells: Int {
        return cellViewModels.count
    }

    private var cellViewModels: [WeatherCellViewModel] = [WeatherCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    func getCellViewModel( at indexPath: IndexPath) -> WeatherCellViewModel? {
        return cellViewModels[indexPath.row]
    }

    private var weathers = [WeatherData]()

    func getAllWeatherInfo( at indexPath: IndexPath) -> WeatherData? {
        return weathers[indexPath.row]
    }

    // MARK: - Logic

    fileprivate func fetchData() {
        self.isLoading = true

        DispatchQueue.global().async { [weak self] in
            guard let citys = self?.citys else {
                return
            }

            for item in citys {
                self?.dataHelper.loadDataByCity(name:item) { [weak self] (weatherData, error) in
                    self?.isLoading = false

                    guard let weatherData = weatherData else {
                        return
                    }

                    let cell = WeatherCellViewModel(cityText: weatherData.name, temperatureText: weatherData.main?.temp)
                    self?.cellViewModels.append(cell)

                    self?.weathers.append(weatherData)
                }
            }
        }
    }
}

struct WeatherCellViewModel {
    let cityText: String?
    let temperatureText: Double?
}
