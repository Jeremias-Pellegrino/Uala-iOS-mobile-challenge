//
//  Parser.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 23/11/2024.
//

import Foundation

class Parser {
    func parse<T:Decodable>(data: Data, to modelOfType: T.Type) throws -> T {
        do {
            let modelInstance = try JSONDecoder().decode(modelOfType.self, from: data)
            return modelInstance
        } catch {
            throw error
        }
    }
}
