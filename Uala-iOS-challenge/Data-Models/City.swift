//
//  City.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI
import CoreLocation

struct Coord: Codable, Hashable {
    let lon: CLLocationDegrees
    let lat: CLLocationDegrees
}

class City: Codable, Hashable, Identifiable, ObservableObject {
    
    enum CodingKeys: String, CodingKey {
        case coord
        case country
        case id = "_id"
        case name
    }
    
    static let dummy: City = City()
    
    let coord: Coord
    let country: String
    var id: Int
    let name: String
    @Published var isFavorite: Bool = false
    
    init(coord: Coord = Coord(lon: 0, lat: 0), 
         country: String = "CT",
         id: Int = UUID().hashValue,
         name: String = "City name",
         isFavorite: Bool = false) {
        self.coord = coord
        self.country = country
        self.id = id
        self.name = name
        self.isFavorite = isFavorite
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
