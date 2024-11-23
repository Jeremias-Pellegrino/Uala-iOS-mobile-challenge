//
//  City.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI

struct City: Decodable, Hashable, Identifiable {
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
    static let dummy: City = City(coord: Coord(lon: 0, lat: 0),
                                  country: "CT",
                                  id: Int.random(in: 0...999),
                                  name: "City name")
    
    let coord: Coord
    let country: String
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case coord
        case country
        case id = "_id"
        case name
    }
}

struct Coord: Codable, Hashable {
    let lon: Float
    let lat: Float
}
