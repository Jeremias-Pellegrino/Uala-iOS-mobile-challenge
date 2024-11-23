//
//  CityViewModel.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI

class CityViewModel: ObservableObject {
    var repository: Repository = Repository()
    var entity: Entity = Entity()
    @Published var showFavorites: Bool = false
    //loaded in-screen cities
    @Published var loadedCities: [City] = [] //this will be Trie's implementation
    var favorites: [City] = []
    
    init() {
        print("initttt")
        Task {
            //Mientras esperamos, mostramos el banner con el spinner cargando
            try await fetch()
            
            
        }
    }
    
    func fetch() async throws {
        print("fetching")
        let data = try await repository.apiClient.requestData(with: repository.url)
        let cities = try Parser().parse(data: data, to: [City].self)
        print(cities)
        let first100 = Array(cities.prefix(100))
        await MainActor.run {
            entity.cities = first100
            self.loadedCities = first100
        }
        
    }
    
    func checkForFavorites() {
        //TODO: adasdasd
    }
}

extension CityViewModel {
    func appendToVisible(_ name: String) {
       //todo
    }
    
    func removeFavorite(_ index: Int) {
        favorites.remove(at: index)
    }
    
    func addFavorite(at offsets: IndexSet) {
        entity.cities.remove(atOffsets: offsets)
        //update the stored file?
    }
}
