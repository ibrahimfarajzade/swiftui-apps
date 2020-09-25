//
//  SetGame.swift
//  SetGame
//
//  Created by Ibrahim Farajzade on 7/11/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var deck = Deck()
    private(set) var dealedCards: [Card] = []
    var score = 0
    
    var cardsRemainingInDeck: Int {
        deck.remainingCardCount
    }
    
    mutating func addCard() -> Card? {
        guard let card = deck.drawCard() else {
            return nil
        }
        
        dealedCards.append(card)
        return card
    }
    
    private mutating func checkMatch() -> State {
        let selectedItems = dealedCards.enumerated().filter { item -> Bool in
            item.element.isSelected
        }
        
        guard selectedItems.count == 3 else { return .selectCard }
        
        var features = [AnyHashable: Int]()
        for (_, card) in selectedItems {
            features[card.number.rawValue, default: 0] += 1
            features[card.color.rawValue, default: 0] += 1
            features[card.shape.rawValue, default: 0] += 1
            features[card.shading.rawValue, default: 0] += 1
        }
        
        let mismatchingFeatures = features.filter { $0.value == 2 }.map { $0.key }
        let isMatch = mismatchingFeatures.isEmpty
        if isMatch {
            for (index, _) in selectedItems {
                dealedCards[index].isMatched = true
            }
        } else {
            for (index, _) in selectedItems {
                dealedCards[index].notMatched = true
            }
        }
        return isMatch ? .match : .noMatch(mismatchingFeatures)
    }
    
    mutating func select(card: Card) -> State {
        // check if we already had previously 3 cards
        let selectedCards = dealedCards.filter { $0.isSelected }
        
        if selectedCards.count == 3 {
            // replace matched cards with new ones
            for card in selectedCards {
                guard let index = dealedCards.firstIndex(of: card) else {
                    print("\(card) suddenly disappeared?!")
                    continue
                }
                if card.isMatched {
                    dealedCards.remove(at: index)
                    
                    if let newCard = deck.drawCard() {
                        dealedCards.insert(newCard, at: index)
                    }
                    score += 3
                } else {
                    dealedCards[index].isSelected.toggle()
                    score -= 1
                }
            }
            
            if dealedCards.isEmpty {
                return .noMoreCards
            }
        }
        
        guard let index = dealedCards.firstIndex(of: card) else {
            return .selectCard
        }
        dealedCards[index].isSelected.toggle()
        
        return checkMatch()
    }
    
    
    enum State {
        case selectCard
        case match
        case noMatch([AnyHashable])
        case noMoreCards
    }
    
    enum Number: Int, CaseIterable, Hashable {
        case one = 1, two, three
    }
    
    enum Color: String, CaseIterable, Hashable {
        case red, purple, green
    }
    
    enum Shape: String, CaseIterable, Hashable, CustomStringConvertible {
        case oval, squiggle, diamond
        
        var description: String {
            switch self {
            case .oval:
                return "0"
            case .squiggle:
                return "~"
            case .diamond:
                return "♢"
            }
        }
    }
    
    enum Shading: String, CaseIterable, Hashable {
        case solid, stripped, outlined
    }
    
    struct Card: Identifiable, Equatable, CustomStringConvertible {
        var isSelected: Bool = false
        var isMatched: Bool = false
        var notMatched: Bool = false
        
        var number: Number
        var color: Color
        var shape: Shape
        var shading: Shading
        
        var id = UUID()
        
        var description: String {
            "Card(\(String(repeating: shape.description, count: number.rawValue)) \(shading) \(color.rawValue))"
        }
    }
    
    struct Deck {
        private var cards: [Card] = []
        
        init() {
            for number in Number.allCases {
                for color in Color.allCases {
                    for shape in Shape.allCases {
                        for shading in Shading.allCases {
                            cards.append(Card(number: number, color: color, shape: shape, shading: shading))
                        }
                    }
                }
            }
            cards.shuffle()
        }
        
        var remainingCardCount: Int {
            cards.count
        }
        
        mutating func drawCard() -> Card? {
            guard cards.count > 0 else {
                return nil
            }
            return cards.removeFirst()
        }
    }
}
