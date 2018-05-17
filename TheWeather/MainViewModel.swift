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

    var citys = ["2147714", "4163971", "2174003"]

    // MARK: - callback
    var reloadTableViewClosure: (() -> Void)?

    func initFetch() {
        fetchData()
    }

    var numberOfCells: Int {
        return cellViewModels.count
    }

    private var cellViewModels: [CityCellViewModel] = [CityCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    func getCellViewModel( at indexPath: IndexPath) -> CityCellViewModel? {
        return cellViewModels[indexPath.row]
    }

    // MARK: - Logic

    fileprivate func fetchData() {

        for item in citys {
            self.dataHelper.loadDataByCity(name:item) { [weak self] (weatherData, error) in
                guard let weatherData = weatherData else {
                    return
                }

                let cell = CityCellViewModel(cityText: weatherData.name, temperatureText: weatherData.main?.temp)
                self?.cellViewModels.append(cell)
            }
        }
    }
}

struct CityCellViewModel {
    let cityText: String?
    let temperatureText: Double?
}
