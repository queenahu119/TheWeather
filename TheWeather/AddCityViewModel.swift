//
//  AddCityViewModel.swift
//  TheWeather
//
//  Created by QueenaHuang on 6/8/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import Foundation
import RealmSwift

let limitNumber:Int = 15

class AddCityViewModel: NSObject {

    fileprivate let dataHelper : DataHelper

    init(dataHelper: DataHelper = DataHelper()) {
        self.dataHelper = dataHelper
    }

    var cities = [City]()
    private var filteredCities: [City] = [City]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    var isSearch: Bool = false

    // MARK: - callback
    var reloadTableViewClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?

    func initFetch() {
        fetchData()
    }

    var numberOfCells: Int {
        if self.isSearch {
            return filteredCities.count
        }
        return cellViewModels.count
    }

    private var cellViewModels: [City] = [City]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    func getCellViewModel( at indexPath: IndexPath) -> City? {
        if (isSearch) {
            return self.filteredCities[indexPath.row]
        } else {
            return  cellViewModels[indexPath.row]
        }
    }

    // MARK: - Logic

    fileprivate func fetchData() {

        let realm = try! Realm()
        let cities = realm.objects(City.self)
        if cities.isEmpty {
            self.isLoading = true
            DispatchQueue.global().async { [weak self] in
                self?.dataHelper.readCityListFile(callback: { (cities, error) in
                    guard let cities = cities else {
                        print("read json file is NULL.")
                        return
                    }

                    DispatchQueue.main.async {
                        self?.isLoading = false
                        print("Add data into Realm.", cities[0].name)
                        self?.cities = cities
                        self?.cellViewModels = Array(cities[0..<limitNumber])
                    }
                })
            }
        } else {
            self.cities = cities.toArray(ofType: City.self)
            self.cellViewModels = Array(self.cities[0..<limitNumber])
        }
    }

    func appendData(start: Int, count: Int) {

        if !self.cities.isEmpty {

            let end = (self.cities.count < start+limitNumber) ? self.cities.count: start+limitNumber
            self.cellViewModels = Array(self.cities[0..<end])
            print("append more data:", self.cellViewModels.count)
        }
    }
    func updateSearchResults(text: String?) {
        if let text = text {
            self.filteredCities = self.cities.filter{(city : City) -> Bool in
                return city.name.lowercased().contains(text.lowercased())
                }

        }
    }

}
