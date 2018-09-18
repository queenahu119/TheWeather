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
            do {
                let data = try Data(contentsOf: url)
                let stream: InputStream = InputStream(data: data)
                stream.open()
                
                // We'll be retrieving data from our stream in the form of a buffer,
                // appending that chunk of data it to this variable, and continuing this
                // process until all the data has been read
                var dataFromStream = Data()
                let bufferSize = 1024 // maximum size for our buffer at any given time
                let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
                while stream.hasBytesAvailable {
                    let outcome = stream.read(buffer, maxLength: bufferSize)
                    if outcome == 0 { // stream has reached its end
                        break
                    } else if outcome == -1 { // error occurred
                        fatalError("error occurred while reading stream")
                    } else if outcome > 0 { // positive outcome represents # of bytes read
                        dataFromStream.append(buffer, count: outcome)
                    } else {
                        fatalError("this should never occur")
                    }
                }
                
                // We're done using our buffer, deallocate it
                buffer.deallocate()
                // We read all our data from the stream, let's close it
                stream.close()
                
                // Now that we've extracted our JSON data from the stream, let's
                // decode it into an array of Posts
                let decoder = JSONDecoder()
                do {
                    let cities = try decoder.decode([City].self, from: dataFromStream)
                    
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
                } catch {
                    fatalError(error.localizedDescription)
                }
            } catch let error as NSError {
                print("Json failed. \(error)")
            }
        }
    }
}
