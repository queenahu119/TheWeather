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
    
    func readJSONFile(callback: @escaping ([City]?, NSError?) -> ()) {
        
        if let url = Bundle.main.url(forResource: "cityList", withExtension: "json") {
            guard let stream = InputStream(fileAtPath: url.path) else {
                fatalError("Could not create stream for url")
            }

            stream.open()
            defer { stream.close() }
            
            let decoder = JSONDecoder()
            do {
                // Read the JSON from our stream
                let json = try JSONSerialization.jsonObject(with: stream, options: [])
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                let cities = try decoder.decode([City].self, from: data)
                
                let dispatchQueue = DispatchQueue(label: "BackgroundRealm", qos: .background)
                dispatchQueue.async {
                    let myBackgroundRealm = try! Realm()
                    
                    for city in cities {
                        try! myBackgroundRealm.write {
                            myBackgroundRealm.create(City.self, value: city, update: false)
                        }
                    }
                }
                callback(cities, nil)
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }
    }
}
