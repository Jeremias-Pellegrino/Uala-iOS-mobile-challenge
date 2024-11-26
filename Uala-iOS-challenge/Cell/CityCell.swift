//
//  CityCell.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI
import CoreLocation

extension CLLocationDegrees {
    func toStr(format: String = "%.2f") -> String {
        return String(format: format, self)
    }
}

struct CityCell: View {
    @Binding var favorites: [City]
    var city: City
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(city.name),").fontWeight(.bold)
                    Text(city.country)
                    Image(systemName: city.isFavorite ? "star.fill" : "star")
                        .onTapGesture {
                            city.isFavorite.toggle()
                            city.isFavorite ? favorites.append(city) : favorites.removeAll {
                                $0.id == self.city.id
                            }
                        }
                        .scaledToFit()
                        .foregroundStyle(city.isFavorite ? Color.yellow : Color.gray)
                }.padding(3)
                Text("\(city.coord.lat.toStr()), \(city.coord.lon.toStr())")
                .padding(3)
            }.padding(3)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .cornerRadius(8)
        .padding(1)
        
    }
}
