//
//  Set+Identifiable.swift
//  EmojiArt
//
//  Created by Ibrahim Farajzade on 8/12/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import Foundation

extension Set where Element: Identifiable {
    mutating func toggleMatching(_ element: Element) {
        if contains(matching: element) {
            remove(element)
        } else {
            insert(element)
        }
    }
}
