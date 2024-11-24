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
    
    private var initialCities: [City] = []
    
    @Published var favorites: [City] = []
    @Published var showFavorites: Bool = false
    
    @Published var searchText: String = ""
    @Published var searchResults: [City] = []
    
    @Published var batchSize = 100
    @Published var loading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            try await fetchDataAndFeedTrie()
            await MainActor.run {
                self.loading.toggle()
            }
        }
        
        trie.$searchResults
            .sink { [weak self] cities in
                var res = cities.sorted { $0.name < $1.name }
                res = Array(res.prefix(self!.batchSize))
                self?.searchResults = res
            }
            .store(in: &cancellables)
        
        $searchText
            .sink { word in
                if word.isEmpty {
                    self.searchResults = Array(self.initialCities.prefix(self.batchSize))
                    return
                }
                self.trie.searchWithPrefix(word)
            }
            .store(in: &cancellables)
    }
    
    func fetchDataAndFeedTrie() async throws {
        let data = try await repository.apiClient.requestData(with: repository.url)
        
        //user initiated queue to make sure
        DispatchQueue(label: "dwnld", qos: .userInitiated).async { [weak self] in
            do {
                var cities = try Parser().parse(data: data, to: [City].self)
                    .sorted { $0.name < $1.name }
                
                //initial sort
                for city in cities {
                    if city.name.hasPrefix("A") {
                        self?.initialCities.append(city)
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
