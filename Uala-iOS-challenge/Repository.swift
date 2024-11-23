//
//  Repository.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias on 22/11/2024.
//

import Foundation

class Repository {

    var apiClient: APIClient = APIClient()
    var dataStorage = DataStorage.shared
    //TODO: move to the repository/viewmodel... get this out of here.
    let url: URL
    
    init() {
        //TODO: fix the force unwrap
        self.url = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json")!
    }
    
}
