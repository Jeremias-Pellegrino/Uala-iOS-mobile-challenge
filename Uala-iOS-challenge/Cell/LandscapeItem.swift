//
//  LandscapeItem.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 26/11/2024.
//

import SwiftUI

struct LandscapeItem: View {
    
    @ObservedObject var viewModel: CitiesViewModel
    let city: City
    @Binding var currentCity: City
    
    var body: some View {
        CityCell(favorites: $viewModel.favorites, city: city)
            .background(currentCity == city ? Color.blue.opacity(0.3) : Color.blue.opacity(0.1))
            .foregroundStyle(Color.black)
            .onTapGesture {
                currentCity = city
            }
    }
}
