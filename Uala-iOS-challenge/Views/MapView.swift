//
//  MapView.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 24/11/2024.
//

import Foundation

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var city: City
    var body: some View {
        Map {
            Marker(city.name, coordinate: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon))
        }
    }
}
