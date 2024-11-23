//
//  Parser.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias on 23/11/2024.
//

import Foundation

enum ParsingErrors: Error { case decodingError }

class Parser {
    
    func parse<T:Decodable>(data: Data, to modelOfType: T.Type) throws -> T {
        do {
            let modelInstance = try JSONDecoder().decode(modelOfType.self, from: data)
            return modelInstance
//
        } catch {
            
            /*
             #if DEBUG:
             //It would be useful try to serialize the data into a JSON, print it, and compare it with our model to verify what went wrong.
             let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
             print("Error decoding data to type:", T.self , "\n", "with JSON:",json!)
             #endif
             **/
            
            throw error
        }
    }
}
