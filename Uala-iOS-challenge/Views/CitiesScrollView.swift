//
//  CitiesScrollView.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 26/11/2024.
//

import SwiftUI

struct CitiesScrollView: View {
    
    @ObservedObject var viewModel: CitiesViewModel
    @Binding var currentCity: City
    
    @State var orientation = UIDevice.current.orientation
    private let orientationChanged = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.displayedCities, id: \.hashValue)
                { city in
                    if orientation.isPortrait {
                        PortraitItem(viewModel: viewModel, city: city)
                    } else {
                        LandscapeItem(viewModel: viewModel, city: city, currentCity: $currentCity)
                    }
                }.clipped()
            }
        }
        .onReceive(orientationChanged) { _ in
            orientation = UIDevice.current.orientation
        }
    }
}
