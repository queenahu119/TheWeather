//
//  City.swift
//  TheWeather
//
//  Created by QueenaHuang on 3/8/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import Foundation
import RealmSwift

class City : Object, Decodable {

    @objc dynamic var id:Int = 0
    @objc dynamic var name:String = ""
    @objc dynamic var country: String?
    @objc dynamic var coord: Coord?

    override static func primaryKey() -> String {
        return "id"
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case country
        case coord
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.country = try container.decode(String.self, forKey: .country)
        self.coord = try container.decode(Coord.self, forKey: .coord)
    }
}

class Coord : Object, Decodable {
    @objc dynamic var lon : Double = 0.0
    @objc dynamic var lat : Double = 0.0
}
