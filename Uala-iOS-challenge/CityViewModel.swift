//
//  CityViewModel.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI
import Combine

class CityViewModel: ObservableObject {
    var repository: Repository = Repository()
    @State private var trie = ObservableTrie()
    
    private var allCities: [String: City] = [:]
    private var initialCities: [City] = []
    
    @Published var favorites: [City] = []
    @Published var showFavorites: Bool = false
    
    @Published var searchText: String = ""
    @Published var searchResults: [City] = []
    
    @Published var batchSize = 100
    @Published var loading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    func setupCities() {
        
    }
    
    init() {
        Task {
            try await fetch()
            setupCities()
        }
        
        trie.$searchResults
            .sink { [weak self] cityNames in
                self?.filterCities(matching: cityNames)
            }
            .store(in: &cancellables)
        
        $searchText
            .sink { word in
                if word == "" {
                    self.searchResults = self.initialCities
                    return
                }
                self.trie.searchWithPrefix(word)
            }
            .store(in: &cancellables)
    }
    
    private func filterCities(matching cityNames: [String]) {
        var res = [City]()
        for name in cityNames {
            res.append(allCities[name]!)
        }
        res = res.sorted { $0.name < $1.name }
        res = Array(res.prefix(batchSize))
        searchResults = res
    }
    
    func fetch() async throws {
        let data = try await repository.apiClient.requestData(with: repository.url)
        DispatchQueue(label: "dwnld", qos: .userInitiated).async {
            do {
                var cities: [City] = []
                cities = try Parser().parse(data: data, to: [City].self)
                print(cities)
                for city in cities {
                    self.allCities[city.name] = city
                    self.trie.insert(city.name)
                }
                
                Task {
                    await MainActor.run {
                        self.loading.toggle()
                        print("done")
                    }
                }
            } catch {
                //Display an alert
                print(error)
            }
        }
    }
    
    func checkForFavorites() {
        
    }
}
