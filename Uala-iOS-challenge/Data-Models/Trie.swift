//
//  Trie.swift
//  Uala-iOS-challenge
//
//  Created by Jeremias Pellegrino on 23/11/2024.
//

import Combine

class ObservableTrie: ObservableObject {
    class TrieNode {
        var char: Character = "\0"
        var city: City? = nil
        var children: [Character: TrieNode] = [:]
        var isEndOfWord = false
    }
    
    private let root: TrieNode = TrieNode()

    func reset() {
        root.children.removeAll()
    }
    
    func insert(_ cities: [City]) {
        cities.forEach { city in
            self.insert(city)
        }
    }
    
    // Insert a word into the Trie
    func insert(_ city: City) {
        var currentNode = root
        for char in city.name.lowercased() {
            
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
    func searchWithPrefix(_ prefix: String) -> [City] {
        var wordMatchingNode = root

        for char in prefix.lowercased() {
            guard let nextNode = wordMatchingNode.children[char] else {
                //no next node means no available matches
                return []
            }
            wordMatchingNode = nextNode
        }
        
        let result = collectWords(from: wordMatchingNode, prefix: prefix)
        return result
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
}
