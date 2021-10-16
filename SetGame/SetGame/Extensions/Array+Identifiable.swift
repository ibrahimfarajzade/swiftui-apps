//
//  Array+Identifiable.swift
//  SetGame
//
//  Created by Ibrahim Farajzade on 7/11/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching item: Element) -> Int? {
        if let index = self.firstIndex(where: { item.id == $0.id }) {
            return index
        }
        return nil
    }
}
