//
//  CityListView.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI

struct CityListView: View {
    
    @State private var showSubMenu = false
    
    @StateObject var viewModel: CityViewModel
    
    @State var showFavorites: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.loadedCities) { city in
                        CityCell(city: city)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.plain)
                .background(Color.clear)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Search")
                    }
                    ToolbarItem(placement: .topBarTrailing)
                    {
                        Image(systemName: showFavorites ? "star.fill" : "star")
                            .onTapGesture {
                                showFavorites.toggle()
                                //filter favorites
                            }
                    }
                }
                .navigationTitle("Cities")
                .toolbarBackground(Color.black, for: .automatic)
                .toolbarRole(.navigationStack)
            }
        }
    }
    
}

#Preview {
    CityListView(viewModel: CityViewModel())
}
