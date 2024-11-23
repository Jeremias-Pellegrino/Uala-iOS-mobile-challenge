//
//  Entity.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import Combine

class Entity: ObservableObject {
    
    @Published var cities: [City] = [City.dummy, City.dummy, City.dummy]

    var favorites: [City] = []
    
    func appendToVisible(_ name: String) {
       //todo
    }
    
    func addFavorite(_ index: Int) {
        let newFav = cities[index]
        favorites.append(newFav)
    }
    
    func removeFavorite(_ index: Int) {
        favorites.remove(at: index)
    }
}
