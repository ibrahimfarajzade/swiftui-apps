//
//  Theme.swift
//  Memorize
//
//  Created by Ibrahim Farajzade on 8/5/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import SwiftUI
import Combine

class Theme: Codable, ObservableObject, Identifiable, Equatable {
    static func == (lhs: Theme, rhs: Theme) -> Bool { lhs.id == rhs.id }
    
    var name: String { willSet { objectWillChange.send() } }
    var emojis: [String] { willSet { objectWillChange.send() } }
    var numberOfPairsOfCards: Int { didSet { objectWillChange.send() } }
    fileprivate var _color: ThemeColor { willSet { objectWillChange.send() } }
    
    var color: UIColor {
        get { _color.uiColor }
        set { _color = ThemeColor(uiColor: newValue)}
    }
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    func add(emojis newEmojis: String) {
        for emoji in newEmojis {
            if !emojis.contains(String(emoji)) {
                emojis.append(String(emoji))
                objectWillChange.send()
            }
        }
    }
    
    func remove(emoji: String) {
        emojis.removeAll(where: { $0 == emoji })
        objectWillChange.send()
    }
    
    init() {
        self.name = "Untitled"
        self.emojis = ["🌎", "🪐"]
        self.numberOfPairsOfCards = 2
        self._color =  ThemeColor(uiColor: .systemTeal)
    }
    
    init?(json: Data?) {
        if json != nil, let newTheme = try? JSONDecoder().decode(Theme.self, from: json!) {
            self.name = newTheme.name
            self.emojis = newTheme.emojis
            self.numberOfPairsOfCards = newTheme.numberOfPairsOfCards
            self._color = newTheme._color
        } else {
            return nil
        }
    }
    
    init(name: String, emojis: [String], numberOfPairsOfCards: Int, color: UIColor) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairsOfCards = numberOfPairsOfCards
        self._color = ThemeColor(uiColor: color)
        
        if self.emojis.count == 0 {
            self.emojis = ["🌎", "🪐"]
        } else if self.emojis.count == 1 {
            self.emojis.append("🌎")
        }
    }
    
    fileprivate struct ThemeColor: Codable {
        var red: CGFloat = -1
        var blue: CGFloat = -1
        var green: CGFloat = -1
        var alpha: CGFloat = -1
        
        init(uiColor: UIColor) {
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
        
        var uiColor: UIColor {
            UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
