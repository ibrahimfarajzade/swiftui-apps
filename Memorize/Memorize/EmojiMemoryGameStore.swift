//
//  EmojiMemoryGameStore.swift
//  Memorize
//
//  Created by Ibrahim Farajzade on 9/3/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import SwiftUI
import Combine

class EmojiMemoryGameStore: ObservableObject {
    let name: String
    
    func add() {
        emojiMemoryGames.append(EmojiMemoryGame())
    }
    
    @discardableResult
    func remove(at index: Int) -> EmojiMemoryGame {
        return emojiMemoryGames.remove(at: index)
    }
    
    func remove(emojiMemoryGame: EmojiMemoryGame) -> Bool {
        if let index = emojiMemoryGames.firstIndex(matching: emojiMemoryGame) {
            emojiMemoryGames.remove(at: index)
            return true
        }
        return false
    }
    
    func addThemes(_ themes: [Theme]) {
        for theme in themes {
            addTheme(theme)
        }
    }
    
    func addTheme(_ theme: Theme) {
        emojiMemoryGames.append(EmojiMemoryGame(theme: theme))
    }
    
    func reset(theme: Theme) {
        if let index = emojiMemoryGames.firstIndex(where: { emojiMemoryGame in emojiMemoryGame.theme == theme }) {
            emojiMemoryGames[index].resetGame()
        }
    }
    
    @Published var emojiMemoryGames: [EmojiMemoryGame]
    
    private var autosave: AnyCancellable?
    
    init (named name: String = "Memorize") {
        self.name = name
        let defaultsKey = "EmojiMemoryGameStore.\(name)"
        emojiMemoryGames = Array(fromPropertyList: UserDefaults.standard.object(forKey: defaultsKey)) ?? []
        autosave = $emojiMemoryGames.sink { emojiMemoryGames in
            UserDefaults.standard.set(emojiMemoryGames.asPropertyList, forKey: defaultsKey)
        }
        
        if emojiMemoryGames.count == 0 {
            addThemes([
                Theme(name: "Halloween", emojis: ["👻", "🎃", "🕷", "🧛‍♀️", "🍬", "🍭"], numberOfPairsOfCards: 6, color : UIColor.systemOrange),
                Theme(name: "Gaming", emojis: ["🎮","🕹","🎳","🎰","👾","🎲","🤖","🏈","🏓","🖥"], numberOfPairsOfCards: 10, color: UIColor.systemBlue),
                Theme(name: "Animals", emojis: ["🐶","🐹","🐰","🦊","🐼","🐨","🐯","🐮","🐵","🐤"], numberOfPairsOfCards: 10, color: UIColor.systemYellow),
                Theme(name: "Fruits", emojis: ["🍎", "🍌", "🍓", "🍒", "🥥", "🍑", "🍇", "🍉", "🍊"], numberOfPairsOfCards: 9, color: UIColor.systemGreen),
                Theme(name: "Signs of Zodiac", emojis: ["♌️", "♍️", "♏️", "♓️", "♉️", "♈️", "⛎", "♒️", "♋️", "⛎", "♊️", "♑️"], numberOfPairsOfCards: 12, color: UIColor.systemPurple),
                Theme(name: "Faces", emojis: ["😀","😅","🤣","😇","😉","😍","😘","😝","🤪","😎","😡","😳","🥶","🤢"], numberOfPairsOfCards: 14, color: UIColor.systemRed),
            ])
        }
    }
}

extension Array where Element == EmojiMemoryGame {
    var asPropertyList: [String] {
        var uuidStrings = [String]()
        for emojiMemoryGame in self {
            uuidStrings.append(emojiMemoryGame.id.uuidString)
        }
        return uuidStrings
    }
    
    init?(fromPropertyList plist: Any?) {
        self.init()
        let uuidStrings = plist as? [String] ?? [String]()
        for uuidString in uuidStrings {
            self.append(EmojiMemoryGame(id: UUID(uuidString: uuidString)))
        }
    }
}
