//
//  DataHelper.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import Foundation
import RealmSwift

let serverURL = "https://api.openweathermap.org/data/2.5/weather"

class DataHelper: NSObject {

    private static var mInstance:DataHelper?
    static func sharedInstance() -> DataHelper {
        if mInstance == nil {
            mInstance = DataHelper()

        }
        return mInstance!
    }

    var cities: [City]? = nil

    override init() {

    }

    func loadDataByCity(id: Int, callback: @escaping (WeatherData?, NSError?) -> ()) {

        var components = URLComponents(string: serverURL)!
        components.queryItems = [
            URLQueryItem(name: "id", value: String(id)),
            URLQueryItem(name: "APPID", value: WeatherClient.AppID),
            URLQueryItem(name: "units", value: "metric")
        ]

        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response , error) in

            if let error = error as NSError? {
                callback(nil, error)
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonData = try decoder.decode(WeatherData.self, from: data)

                    callback(jsonData, nil)
                } catch let error as NSError {
                    print("Json failed. \(error)")
                    callback(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func readCityListFile(callback: @escaping ([City]?, NSError?) -> ()) {

        if let url = Bundle.main.url(forResource: "cityList", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([City].self, from: data)
                print("Json data:", jsonData.count)

                let realm = try! Realm()
                for city in jsonData {
                    do {
                        let isFound = realm.objects(City.self).filter("name == %@", city.name).first
                        if (isFound == nil) {
                            try realm.write ({
                                print("city:", city.name)
                                realm.add(city)
                            })
                        }
                    } catch let error as NSError {
                        // handle error
                        print("Realm Save object failed: ", error)
                    }
                }

                let cities = realm.objects(City.self).toArray(ofType: City.self)
                callback(cities, nil)
            } catch let error as NSError {
                print("Json failed. \(error)")
                callback(nil, error)
            }
        }
    }

    func readCityListFile() {

        if let url = Bundle.main.url(forResource: "cityList", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let cities = try decoder.decode([City].self, from: data)

                print("Json data:", cities.count)

                DispatchQueue.main.async {
                    let realm = try! Realm()
                    for city in cities {
                        try! realm.write {
                            realm.add(city)
                        }
                    }
                }

            } catch let error as NSError {
                print("Json failed. \(error)")
            }
        }
    }
}
