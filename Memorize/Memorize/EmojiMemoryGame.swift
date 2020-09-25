//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ibrahim Farajzade on 8/4/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import SwiftUI
import Combine

class EmojiMemoryGame: ObservableObject, Identifiable {
    @Published private var memoryGame: MemoryGame<String>
    
    private static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
        let emojis = EmojiMemoryGame.getPlayableEmojis(theme: theme)
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in emojis[pairIndex] }
    }
    
    @Published private(set) var theme: Theme
    
    private var autosaveCancellable: AnyCancellable?
    
    let id: UUID
    
    init(theme: Theme) {
            self.id = UUID()
            let defaultsKey = "EmojiMemoryGame.\(self.id.uuidString)"
            self.memoryGame = EmojiMemoryGame.createMemoryGame(with: theme)
            self.theme = theme
            self.autosaveCancellable = self.$theme.sink { theme in
                print("testing")
                UserDefaults.standard.set(theme.json, forKey: defaultsKey)
            }
        }
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultsKey = "EmojiMemoryGame.\(self.id.uuidString)"
        let theme = Theme(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? Theme()
        self.memoryGame = EmojiMemoryGame.createMemoryGame(with: theme)
        self.theme = theme
        self.autosaveCancellable = self.$theme.sink { theme in
            print(theme.json!.utf8!)
            UserDefaults.standard.set(theme.json, forKey: defaultsKey)
        }
    }
    
    private static func getPlayableEmojis(theme: Theme) -> [String] {
        switch(theme.emojis.count) {
        case 0:
            return ["🌎", "🪐"]
        case 1:
            if theme.emojis[0] == "🌎" {
                return ["🪐", theme.emojis[0]]
            } else {
                return ["🌎", theme.emojis[0]]
            }
        default:
            return theme.emojis
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: [MemoryGame<String>.Card] { memoryGame.cards }
    
    var score: Int { return memoryGame.score }
    
    var themeName: String { theme.name.capitalized }
    
    var themeColor: Color { return Color(theme.color) }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) { memoryGame.choose(card: card) }
    
    func resetGame() { memoryGame = EmojiMemoryGame.createMemoryGame(with: theme) }
}
