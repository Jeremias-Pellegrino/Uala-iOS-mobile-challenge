//
//  FavsStorage.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import SwiftUI

///Persist favorites between launches
class Storage {
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("favs.data")
    }
    
    func loadFromUserDefaults() -> [City] {
        var favs: [City] = []
        if let data = UserDefaults.standard.data(forKey: "favs"),
           let decoded = try? JSONDecoder().decode([City].self, from: data) {
            favs = decoded
        }
        return favs
    }
    
    func saveToUserDefaults(favs: [City]) {
        if let encoded = try? JSONEncoder().encode(favs) {
            UserDefaults.standard.set(encoded, forKey: "favs")
        }
    }
    
    //MARK: In case the user favs 50.000+ elements or it's considered quite valuable information, it might be wise consider storing data using fileManager or another alternatives to user defaults.
    func loadFromDisk() -> [City]? {
        guard let fileURL = try? Self.fileURL() else { return nil }
        guard let data = try? Data(contentsOf: fileURL) else {
            return []
        }
        return try? JSONDecoder().decode([City].self, from: data)
    }
    
    func saveToDisk(favs: [City]) async {
        let task = Task {
            let data = try JSONEncoder().encode(favs)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        do {
            _ = try await task.value
        } catch {
            print(error)
        }
    }
}
