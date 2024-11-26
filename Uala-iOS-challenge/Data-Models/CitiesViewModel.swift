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
    private var cities: [City] = []
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
    var batchSize = 100
    @Published var batchesDisplayed = 1
    @Published var loading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        setupFavs()
        
        Task { @MainActor in
            try await fetchDataAndFeedTrie()
        }
        
        $favorites
            .sink { [weak self] favs in
                guard let self = self else { return }
                self.repository.dataStorage.saveToUserDefaults(favs: favs)
            }.store(in: &cancellables)
        
//        $batchesDisplayed
//            .sink { [weak self] size in
//                guard let self = self, !self.loading else { return }
//                self.landingCities.append(contentsOf: self.cities[self.batchSize...self.batchSize*2])
//            }.store(in: &cancellables)

        $searchResults
            .map { cities in
                return Array(cities.prefix(self.batchSize))
            }
            .assign(to: &$displayedCities)
        
        Publishers.CombineLatest3($showFavorites, $searchText, $favorites)
            .map { showFavorites, searchText, favorites in
                
                if self.loading { return [] }
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
    
    func setupFavs() {
        self.favorites = self.repository.dataStorage.loadFromUserDefaults()
        for item in self.favorites {
            item.isFavorite = true
        }
    }
    
    func fetchDataAndFeedTrie() async throws {
        let data = try await repository.apiClient.requestData(with: repository.url)
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            do {
                guard let self = self else { return }
                self.cities = try Parser().parse(data: data, to: [City].self)
                    .sorted { $0.name < $1.name }
                
                for city in cities {
                    if self.favorites.contains(city) {
                        city.isFavorite = true
                        print("agregando fav a trie:", city.name, city.id, city.isFavorite)
                    }
                    self.trie.insert(city)
                }
                
                for idx in 0..<self.batchSize {
                    self.landingCities.append(cities[idx])
                }
                
                Task(priority: .userInitiated) { @MainActor in
                    self.displayedCities = self.landingCities
                    self.loading.toggle()
                }
                
            } catch {
                //Display an alert
                print(error)
            }
        }
    }
}
