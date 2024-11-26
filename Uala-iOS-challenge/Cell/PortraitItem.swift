//
//  PortraitItem.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 26/11/2024.
//

import SwiftUI

struct PortraitItem: View {
    
    @ObservedObject var viewModel: CitiesViewModel
    let city: City
    
    var body: some View {
        
        NavigationLink(destination: {
            MapView(city: Binding.constant(city))
        }) {
            CityCell(favorites: $viewModel.favorites, city: city)
        }
        .background(Color(red: 0.9, green: 0.9, blue: 0.96))
        .foregroundStyle(Color.black)
    }
}
