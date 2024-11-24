//
//  CityListView.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI

struct CityListView: View {
    
    @StateObject var viewModel: CityViewModel = CityViewModel()
    @State private var scrollID: String? = ""
    
    
    var body: some View {
        if viewModel.loading {
            Text("loading")
                .padding()
        }
        else {
            NavigationView {
                VStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.searchResults,
                                    id: \.self) { city in
                                NavigationLink(destination: MapView()) {
                                    CityCell(city: city)
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    //                .background(Color.red.opacity(0.2))
                    //                .contentMargins(.horizontal, 10, for: .scrollContent)
                    .scrollPosition(id: $scrollID)
                    .onChange(of: scrollID) { oldValue, newValue in
                        //pull more values at the bototm
                        print("scrolled to:", newValue)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        TextField("Search...", text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    ToolbarItem(placement: .topBarTrailing)
                    {
                        Image(systemName: viewModel.showFavorites ? "star.fill" : "star")
                            .onTapGesture {
                                viewModel.showFavorites.toggle()
                                //filter favorites
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    CityListView()
}
