//
//  APIClient.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 22/11/2024.
//

import Foundation

struct HTTPResponseCode {
    
    enum HTTPResponseCategory: Error {
        case informativeResponse(Int)
        case satisfactoryResponse(Int)
        case clientError(Int)
        case redirection(Int)
        case serverError(Int)
        case other(Int)
    }
    
    let category: HTTPResponseCategory
    var isSatisfactory: Bool = false
    
    init(_ code: Int) {
        switch code {
        case 100...199:
            category = .informativeResponse(code)
        case 200...299:
            category = .satisfactoryResponse(code)
            isSatisfactory = true
        case 300...399:
            category = .redirection(code)
        case 400...499:
            category = .clientError(code)
        case 500...599:
            category = .serverError(code)
        default:
            category = .other(code)
        }
    }
}

class APIClient {
    
    //TODO: Consider replacing this with NSCache to improve performance
    let cache: URLCache
    
    init() {
        
        //TODO: Verify if the size is enough to store the 200k items.
        cache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                         diskCapacity: 200 * 1024 * 1024,
                         diskPath: nil)
    }
    
    //    deinit {
    //        cache.removeAllCachedResponses()
    //    }
    
    func requestData(with url: URL, shouldCache: Bool = true) async throws -> Data {
        
        let cacheRef = cache
        
        //TODO: May want add check conditions to verify the current data correctnes, etc. For the purposes of this challenge, the data remains constant, so we don't need to.
        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)) {
            return cachedResponse.data
        }
        
        return try await startDataTask(url: url, shouldCache: shouldCache)
    }
    
    //TODO: run on background / low priority thread
    func startDataTask(url: URL, shouldCache: Bool = false) async throws -> Data {
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let validResponse = response as? HTTPURLResponse
        else {
            throw URLError(.badServerResponse, userInfo: [:])
        }
        
        let responseCode = HTTPResponseCode(validResponse.statusCode)
        
        if !responseCode.isSatisfactory {
            throw responseCode.category
        }
        
//        if shouldCache {
//            let cachedResponse = CachedURLResponse(response: response, data: data)
//        }
        
        return data
    }
}
