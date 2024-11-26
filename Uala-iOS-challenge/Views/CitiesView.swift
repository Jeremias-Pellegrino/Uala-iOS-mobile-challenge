//
//  CityListView.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI
import CoreLocation

struct CitiesView: View {
    
    @ObservedObject var viewModel: CitiesViewModel = CitiesViewModel()
    
    var body: some View {
        
        HStack {
            if viewModel.loading {
                Text("loading")
                    .padding()
            }
            else {
                CitiesNavContainer(viewModel: viewModel)//, currentCity: $currentCity)
            }
        }
    }
    
}
