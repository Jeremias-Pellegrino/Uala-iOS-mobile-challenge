//
//  CityCell.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI

extension Float {
    func toStr(format: String = "%.2f") -> String {
        return String(format: format, self)
    }
}

struct FontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(Fonts.avenir.font()
            .weight(.medium))
    }
}

struct CityCell: View {
    
    //@ObservedObject
    let country: String
    let lat: String
    let lon: String
    let name: String
    
    init(city: City) {
        self.country = city.country
        self.lat = city.coord.lat.toStr()
        self.lon = city.coord.lon.toStr()
        self.name = city.name
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(name),").fontWeight(.bold)
                    Text(country)
                }
                Text("\(lat), \(lon)")
            }
            Spacer()
            Button("Info") {
                print("TOUCH cell")
            }.onTapGesture {
                print("TOUCH BUTTON")
            }
        }.modifier(FontModifier())
    }
}


#Preview {
    List {
        CityCell(city: City.dummy)
        CityCell(city: City.dummy)
        CityCell(city: City.dummy)
        CityCell(city: City.dummy)
        CityCell(city: City.dummy)
    }
}

