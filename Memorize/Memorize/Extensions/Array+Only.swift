//
//  Array+Only.swift
//  Memorize
//
//  Created by Ibrahim Farajzade on 8/5/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
