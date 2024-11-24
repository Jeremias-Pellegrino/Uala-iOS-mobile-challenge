//
//  Trie.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias on 23/11/2024.
//

import SwiftUI

class ObservableTrie2: ObservableObject {
    class TrieNode {
        var char: Character = "\0"
        var city: City = City.dummy
        var children: [Character: TrieNode] = [:]
        var isEndOfWord = false
    }
    
    private let root: TrieNode
    private var nodesHistory: [TrieNode]
    
    @Published var searchResults: [[City]] = [[]]
    
    func insert(_ cities: [City]) {
        cities.forEach { city in
            self.insert(city)
        }
    }
    
    init(items: [City] = []) {
        root = TrieNode()
        nodesHistory = [root]
        printChildren(root)
    }
    
    func printChildren(_ node: TrieNode) {
//        print(node.char)
        for child in node.children.values {
            printChildren(child)
        }
    }
    
    // Insert a word into the Trie
    func insert(_ city: City) {
        var currentNode = root
        for char in city.name {
            if currentNode.children[char] == nil {
                let newNode = TrieNode()
                newNode.char = char
                newNode.city = city
                currentNode.children[char] = newNode
            }
            currentNode = currentNode.children[char]!
        }
        currentNode.isEndOfWord = true
    }
    
    // Search for words with a prefix
    func searchWithPrefix(_ prefix: String) {
        
        //optimizar despues? es para ejecutar el analisis desde el nodo anterior en vez de comenzar desde el root de nuevo.
        //        guard let currentNode = nodesHistory.last else {
        //            searchResults = [[]]
        //            return
        //        }
        //
        //        for char in prefix {
        //            guard let nextNode = currentNode.children[char] else {
        //                searchResults = [[]]
        //                return
        //            }
        //            currentNode = nextNode
        //                }
        
        var currentNode = root
        for char in prefix {
            guard let nextNode = currentNode.children[char] else {
                searchResults = [[]]
                return
            }
            currentNode = nextNode
        }
        
        let result = collectWords(from: currentNode, prefix: prefix)
        searchResults = paginate(array: result, itemsPerPage: 30)
    }
    
    private func collectWords(from node: TrieNode, prefix: String) -> [City] {
        var cities = [City]()
        if node.isEndOfWord {
            cities.append(node.city)
        }
        
        for (char, childNode) in node.children {
            cities += collectWords(from: childNode, prefix: prefix + String(char))
        }
        
        return cities
    }
    
    func paginate<T>(array: [T], itemsPerPage: Int) -> [[T]] {
        return stride(from: 0, to: array.count, by: itemsPerPage).map {
            Array(array[$0..<min($0 + itemsPerPage, array.count)])
        }
    }
}

class ObservableTrie: ObservableObject {
    class TrieNode {
        var char: Character = "\0"
        var children: [Character: TrieNode] = [:]
        var isEndOfWord = false
    }
    
    private let root: TrieNode
    private var nodesHistory: [TrieNode]
    
//    @Published var searchResults: [[String]] = [[]]
    @Published var searchResults: [String] = []

    func insert(_ words: [String]) {
        words.forEach { word in
            self.insert(word)
        }
    }
    
    init(items: [String] = [""]) {
        root = TrieNode()
        nodesHistory = [root]
        
    
        
//        for i in 0..<1000 {
//            self.insert("Apple\(i)")
//            //            self.insert("App\(i)")
//            //            self.insert("Application\(i)")
//            //            self.insert("Banana\(i)")
//        }
//        printChildren(root)
    }
    
    func printChildren(_ node: TrieNode) {
//        print(node.char)
        for child in node.children.values {
            printChildren(child)
        }
    }
    
    // Insert a word into the Trie
    func insert(_ word: String) {
        var currentNode = root
        for char in word {
            if currentNode.children[char] == nil {
                let newNode = TrieNode()
                newNode.char = char
                currentNode.children[char] = newNode
            }
            currentNode = currentNode.children[char]!
        }
        currentNode.isEndOfWord = true
    }
    
    // Search for words with a prefix
    func searchWithPrefix(_ prefix: String) {
        
        //optimizar despues? es para ejecutar el analisis desde el nodo anterior en vez de comenzar desde el root de nuevo.
        //        guard let currentNode = nodesHistory.last else {
        //            searchResults = [[]]
        //            return
        //        }
        //
        //        for char in prefix {
        //            guard let nextNode = currentNode.children[char] else {
        //                searchResults = [[]]
        //                return
        //            }
        //            currentNode = nextNode
        //                }
        
        var currentNode = root
        for char in prefix {
            guard let nextNode = currentNode.children[char] else {
//                searchResults = [[]]
                searchResults = []
                return
            }
            currentNode = nextNode
        }
        
        let result = collectWords(from: currentNode, prefix: prefix)
        searchResults = result
//        searchResults = paginate(array: result, itemsPerPage: 30)
    }
    
    private func collectWords(from node: TrieNode, prefix: String) -> [String] {
        var words = [String]()
        if node.isEndOfWord {
            words.append(prefix)
        }
        for (char, childNode) in node.children {
            words += collectWords(from: childNode, prefix: prefix + String(char))
        }
        
        return words
    }
    
    func paginate<T>(array: [T], itemsPerPage: Int) -> [[T]] {
        return stride(from: 0, to: array.count, by: itemsPerPage).map {
            Array(array[$0..<min($0 + itemsPerPage, array.count)])
        }
    }
}
