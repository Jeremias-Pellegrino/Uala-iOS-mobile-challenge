//
//  City.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI

struct City: Codable {
    
    static let dummy: City = City(coord: Coord(lon: 0, lat: 0), country: "Country", _id: 999, name: "City name")
    
    let coord: Coord
    let country: String
    let _id: Int
    let name: String
}

struct Coord: Codable {
    let lon: Float
    let lat: Float
}
