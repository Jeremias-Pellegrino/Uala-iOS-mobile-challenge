//
//  Fonts.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI

enum Fonts {
    case sanFrancisco
    case sanFranciscoRounded
    case sanFranciscoMonospaced
    case newYorkSerif
    case sfCompact
    case chalkboard
    case markerFelt
    case avenir
    case courier
    case helveticaNeue
    case annaiMn

    func font(size: CGFloat = 20) -> Font {
        switch self {
        case .sanFrancisco:
            return .system(size: size)
        case .sanFranciscoRounded:
            return .system(size: size, design: .rounded)
        case .sanFranciscoMonospaced:
            return .system(size: size, design: .monospaced)
        case .newYorkSerif:
            return .system(size: size, design: .serif)
        case .sfCompact:
            return .custom("SFCompactText-Regular", size: size)
        case .chalkboard:
            return .custom("ChalkboardSE-Regular", size: size)
        case .markerFelt:
            return .custom("MarkerFelt-Wide", size: size)
        case .avenir:
            return .custom("Avenir-Book", size: size)
        case .courier:
            return .custom("Courier", size: size)
        case .helveticaNeue:
            return .custom("HelveticaNeue", size: size)
        case .annaiMn:
            return .custom("Annai-MN", size: size)
        }
    }
}

struct FontModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(Fonts.avenir.font()
            .weight(.medium))
    }
}
