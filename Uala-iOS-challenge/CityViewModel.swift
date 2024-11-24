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
    var entity: Entity = Entity()
    
    @State private var trie = ObservableTrie()
    
    @Published var showFavorites: Bool = false
    var favorites: [City] = []
    
    @Published var searchText: String = ""
    
    @Published var searchResults: [City] = []
    
    private var allCities: [String: City] = [:]
    
    @Published var loading: Bool = true
    
    @State var currentPage = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("initttt")
        Task {
            //Mientras esperamos, mostramos el banner con el spinner cargando
            try await fetch()
        }
        
        trie.$searchResults
            .sink { [weak self] cityNames in
                self?.filterCities(matching: cityNames)
                
            }
            .store(in: &cancellables)
        
        $searchText
//            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .sink { word in
                if word == "" { return }
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
        res = Array(res.prefix(100))
        searchResults = res
    }
    
    func fetch() async throws {
        print("fetching")
        
        
        let data = try await repository.apiClient.requestData(with: repository.url)
        DispatchQueue(label: "dwnld", qos: .background).async {
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
                print(error)
            }
        }
       
//        let first100 = Array(cities.prefix(100))
        
        //TODO: parsear las cities en el diccionario de un saque, en el mismo modelo asi no hago el laburo de recorrer 200k items dos veces.
        
        
        //feed trie
     
        
//        await MainActor.run {
//            entity.cities = first100
//        }
    }
    
//    func itemsToRender() -> [String] {
//        var items: [String] = []
//        for i in 0...currentPage {
//            items.append(contentsOf: trie.searchResults[i])
//        }
//        
//        return items
//    }
    
    
    func checkForFavorites() {
        //TODO: adasdasd
    }
    
//    func searchWithPrefix(_ prefix: String) {
//        
//        let results = trie.searchResults(for: prefix)
//        print(results)
//        currentPage = 0
//    }
    
    //should be ID
//    func updatePagination(lastItemID: String) {
//        print(lastItemName ?? "")
//        
//        let pageSize = 30
//        if lastItemName == trie.searchResults[currentPage][pageSize - 10]  {
//            if currentPage < trie.searchResults.count {
//                currentPage += 1
//            }
//        }
//    }
    
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
