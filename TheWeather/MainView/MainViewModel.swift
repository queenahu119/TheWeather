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

    var citys: [Int] = []

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    // MARK: - callback
    var reloadTableViewClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?

    func initFetch() {

        if let list = UserDefaults.standard.array(forKey: "defaultCities") as? [Int] {
            self.citys = list
        } else {
            self.citys = [2147714, 7839805, 2174003]
            UserDefaults.standard.set(self.citys, forKey: "defaultCities")
        }

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

    func fetchData() {

        DispatchQueue.global().async { [weak self] () in
            self?.isLoading = true
            guard let citys = self?.citys else {
                return
            }

            // Reset
            self?.cellViewModels.removeAll()
            self?.weathers.removeAll()

            for item in citys {
                self?.loadCityData(id: item)
            }
        }
    }

    func loadCityData(id: Int) {
        self.dataHelper.loadDataByCity(id: id) { [weak self] (weatherData, _) in
            self?.isLoading = false
            guard let weatherData = weatherData else {
                return
            }

            let cell = WeatherCellViewModel(cityText: weatherData.name, temperatureText: weatherData.main?.temp)
            self?.cellViewModels.append(cell)
            self?.weathers.append(weatherData)
        }
    }

    func addCity(id:Int) {
        self.citys.append(id)
        UserDefaults.standard.set(self.citys, forKey: "defaultCities")

        self.loadCityData(id: id)
    }
}

struct WeatherCellViewModel {
    let cityText: String?
    let temperatureText: Double?
}
