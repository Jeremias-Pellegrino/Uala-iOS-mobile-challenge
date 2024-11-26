//
//  PortraitView.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 25/11/2024.
//

import SwiftUI

struct CitiesNavContainer: View {

    @State var orientation = UIDevice.current.orientation
    private let orientationChanged = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
   
    @ObservedObject var viewModel: CitiesViewModel
    @State var currentCity: City = City.dummy
    
    var body: some View {
        ZStack {
            if orientation.isPortrait {
                CitiesNav(viewModel: viewModel, currentCity: $currentCity)
            } else {
                HStack {
                    CitiesNav(viewModel: viewModel, currentCity: $currentCity)
                    MapView(city: $currentCity)
                }
            }
        }.onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
            UINavigationBar.appearance().standardAppearance = appearance
        }
        .onReceive(orientationChanged) { _ in
            orientation = UIDevice.current.orientation
        }
        .onReceive(viewModel.$loading ) { loading in
            if !loading, let firstCity =  viewModel.displayedCities.first {
                currentCity = firstCity
            }
        }
    }
}
