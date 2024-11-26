//
//  CitiesToolbarContent.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 26/11/2024.
//

import SwiftUI

struct CitiesToolbarContent: ToolbarContent {
    
    @Binding var showFavorites: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Image(systemName: showFavorites ? "star.fill" : "star")
                .onTapGesture {
                    showFavorites.toggle()
                }
                .padding()
                .foregroundStyle(showFavorites ? Color.yellow : Color.black)
        }
    }
}
