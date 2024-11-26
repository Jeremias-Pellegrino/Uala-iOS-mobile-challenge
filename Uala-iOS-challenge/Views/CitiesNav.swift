//
//  CitiesNav.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 26/11/2024.
//

import SwiftUI

struct CitiesNav: View {
    
    struct NavModifier: ViewModifier {
        @ObservedObject var viewModel: CitiesViewModel
        func body(content: Content) -> some View {
            content.navigationTitle("Cities")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $viewModel.searchText,
                            placement: .navigationBarDrawer(displayMode: .always))
        }
    }
    
    @ObservedObject var viewModel: CitiesViewModel
    @Binding var currentCity: City
    
    var body: some View {
        NavigationStack {
            CitiesScrollView(viewModel: viewModel, currentCity: $currentCity)
                .modifier(NavModifier(viewModel: viewModel))
                .toolbar {
                    CitiesToolbarContent(showFavorites: $viewModel.showFavorites)
                }
        }
    }
}
