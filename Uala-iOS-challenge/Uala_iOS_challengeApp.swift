//
//  Uala_iOS_challengeApp.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI

@main
struct Uala_iOS_challengeApp: App {
    var body: some Scene {
        WindowGroup {
            CitiesView()
                .modifier(FontModifier())
        }
    }
}
