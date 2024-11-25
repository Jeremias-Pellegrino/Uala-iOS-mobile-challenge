//
//  CityViewModel.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI
import Combine

class CitiesViewModel: ObservableObject {
    var repository: Repository = Repository()
    
    //Cities
    private var landingCities: [City] = []
    @State private var trie = ObservableTrie()
    @Published var displayedCities: [City] = []
    
    //Favorites
    @Published var favorites: [City] = []
    @Published var showFavorites: Bool = false

    //Search
    @Published var searchText: String = ""
    @Published var searchResults: [City] = []
    
    //Loading tweaks
    @Published var batchSize = 100
    @Published var loading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        Task {
            try await fetchDataAndFeedTrie()
            await MainActor.run {
                self.displayedCities = self.landingCities
                self.loading.toggle()
            }
        }

        $batchSize
            .sink { size in
                //update landing cities size when the batch updates
            }.store(in: &cancellables)
        
        $searchResults
            .map { cities in
                return Array(cities.prefix(self.batchSize))
            }
            .assign(to: &$displayedCities)
        
        Publishers.CombineLatest3($showFavorites, $searchText, $favorites)
            .map { showFavorites, searchText, favorites in
                
                let lowercased = searchText.lowercased()
                var results = [City]()
                
                //no filtering
                if searchText.isEmpty {
                    results = showFavorites ? favorites : self.landingCities
                }
                
                //filter case
                else {
                    results = self.trie.searchWithPrefix(lowercased)
                    if showFavorites {
                        results = results.filter{ $0.isFavorite }
                    }
                }
                return results.sorted { $0.name < $1.name }
            }
            .receive(on: RunLoop.main)
            .assign(to: &$searchResults)

    }
    
    func fetchDataAndFeedTrie() async throws {
        let data = try await repository.apiClient.requestData(with: repository.url)
        
        //user initiated queue to make sure
        DispatchQueue(label: "dwnld", qos: .userInitiated).async { [weak self] in
            do {
                //TODO: ahora que guardo las cities directamente en los nodos puedo lowcasear aca derecho y despues comparar con el lowcase del input y ya.
                let cities = try Parser().parse(data: data, to: [City].self)
                    .sorted { $0.name < $1.name }
                
                for idx in 0..<self!.batchSize {
                    self?.landingCities.append(cities[idx])
                }
                
                for city in cities {
                    if self!.favorites.contains(city) {
                        city.isFavorite = true
                    }
                    self?.trie.insert(city)
                }
            } catch {
                //Display an alert
                print(error)
            }
        }
    }
}
