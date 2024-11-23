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
        var children: [Character: TrieNode] = [:]
        var isEndOfWord = false
    }
    
    private let root: TrieNode
    private var nodesHistory: [TrieNode]
    
    @Published var searchResults: [[String]] = [[]]
    
    init(items: [String] = [""]) {
        root = TrieNode()
        nodesHistory = [root]
        
        //        items.forEach { word in
        //            self.insert(word)
        //        }
                for i in 0..<100 {
                    self.insert("Apple\(i)")
        //            self.insert("App\(i)")
        //            self.insert("Application\(i)")
        //            self.insert("Banana\(i)")
                }
        printChildren(root)
    }
    
    func printChildren(_ node: TrieNode) {
        print(node.char)
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
        for char in prefix {
            guard let nextNode = currentNode.children[char] else {
                searchResults = [[]]
                return
            }
            currentNode = nextNode
        }
        let result = collectWords(from: currentNode, prefix: prefix)
        searchResults = divideArrayIntoChunks(array: result, chunkSize: 30)
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
    
    func divideArrayIntoChunks<T>(array: [T], chunkSize: Int) -> [[T]] {
        return stride(from: 0, to: array.count, by: chunkSize).map {
            Array(array[$0..<min($0 + chunkSize, array.count)])
        }
    }
}

struct ContentView: View {
    
    private var debounceTimer: DispatchWorkItem?
    
    @StateObject private var trie = ObservableTrie()
    @State private var searchText = ""
    @State var pages = 0
    
    var body: some View {
        VStack {
            TextField("Search...", text: $searchText)
                //TODO: check for reading the binding $searchText
                .onChange(of: searchText) { _, newvalue in
                    let caseInsensitive = newvalue.lowercased()
                    trie.searchWithPrefix(newvalue)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List(trie.searchResults[pages],
                 id: \.self) { word in
                Text(word)
            }
        }
        .onAppear {
            print("onappear")
            
        }
    }
    
//    mutating func debounce(_ newValue: String) {
//            // Cancel any existing timer
//            debounceTimer?.cancel()
//            
//            // Set up a new debounce timer
//            debounceTimer = DispatchWorkItem { [weak self] in
//                self?.debouncedText = newValue
//                // Perform your heavy operation here
//                print("Debounced value: \(newValue)")
//            }
//            
//            // Perform the action after 0.3 seconds of inactivity
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: debounceTimer!)
//        }
}

#Preview {
    ContentView()
}
