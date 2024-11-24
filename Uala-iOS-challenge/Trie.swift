//
//  Trie.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias on 23/11/2024.
//

import SwiftUI

class ObservableTrie: ObservableObject {
    class TrieNode {
        var char: Character = "\0"
        var city: City? = nil
        var children: [Character: TrieNode] = [:]
        var isEndOfWord = false
    }
    
    private let root: TrieNode
    private var nodesHistory: [TrieNode]
    
    @Published var searchResults: [City] = []
    
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
        for child in node.children.values {
            printChildren(child)
        }
    }
    
    // Insert a word into the Trie
    func insert(_ city: City) {
        var currentNode = root
        for char in city.name {
            
            //end of the word
            if currentNode.children[char] == nil {
                let newNode = TrieNode()
                newNode.char = char
                currentNode.children[char] = newNode
            }
            currentNode = currentNode.children[char]!
        }
        currentNode.city = city
        currentNode.isEndOfWord = true
    }
    
    // Search for words with a prefix
    func searchWithPrefix(_ prefix: String) {        
        var wordMatchingNode = root

        for char in prefix {
            guard let nextNode = wordMatchingNode.children[char] else {
                //no next node means no available matches
                searchResults = []
                return
            }
            wordMatchingNode = nextNode
        }
        
        let result = collectWords(from: wordMatchingNode, prefix: prefix)
//        searchResults = paginate(array: result, itemsPerPage: 30)
        searchResults = result
    }
    
    private func collectWords(from node: TrieNode, prefix: String) -> [City] {
        var cities = [City]()
        if node.isEndOfWord, let city = node.city {
            cities.append(city)
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
