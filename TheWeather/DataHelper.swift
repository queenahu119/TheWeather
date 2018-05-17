//
//  DataHelper.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import Foundation

class DataHelper: NSObject {

    func loadDataByCity(name: String, callback: @escaping (WeatherData?, NSError?) -> ()) {

        var components = URLComponents(string: WeatherClient.Server)!
        components.queryItems = [
            URLQueryItem(name: "id", value: name),
            URLQueryItem(name: "APPID", value: WeatherClient.AppID)
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
}
