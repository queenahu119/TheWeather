//
//  WeatherData.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    var id: Int
    var name: String
    var weather: [WeatherInfo?]
    var coord: Coordinate?
    var base: String?
    var main: MainInfo?
    var wind: WindInfo?
    var clouds: CloudInfo?
    var rain: VolumeInfo?
    var snow: VolumeInfo?
    var sys: SystemInfo?
    var dt: Int? // Time of data calculation, unix, UTC
    var cod: Int? // Internal parameter
    var visibility: Int?
}

struct Coordinate: Decodable {
    var lon: Double?
    var lat: Double?
}

struct WeatherInfo: Decodable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct MainInfo: Decodable {
    var temp: Double?
    var pressure: Int?
    var humidity: Int?
    var tempMin: Double?
    var tempMax: Double?
}

struct WindInfo: Decodable {
    var speed: Double?
    var degrees: Double?

    private enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
}

struct CloudInfo: Decodable {
    var all: Int?
}

struct VolumeInfo: Decodable {
    var volume: Int? // for the last 3 hours

    private enum CodingKeys: String, CodingKey {
        case volume = "3h"
    }
}

struct SystemInfo: Decodable {
    var type: Int?
    var id: Int?
    var message: Double?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
}
