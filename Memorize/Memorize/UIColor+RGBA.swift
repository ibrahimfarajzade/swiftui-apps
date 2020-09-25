//
//  UIColor+RGBA.swift
//  Memorize
//
//  Created by Ibrahim Farajzade on 8/6/20.
//  Copyright © 2020 Ibrahim Farajzade. All rights reserved.
//

import SwiftUI

extension UIColor {
  static func == (lhs: UIColor, rhs: UIColor) -> Bool {
    var lhsR: CGFloat = 0
    var lhsG: CGFloat = 0
    var lhsB: CGFloat = 0
    var lhsA: CGFloat = 0
    lhs.getRed(&lhsR, green: &lhsG, blue: &lhsB, alpha: &lhsA)
    var rhsR: CGFloat = 0
    var rhsG: CGFloat = 0
    var rhsB: CGFloat = 0
    var rhsA: CGFloat = 0
    rhs.getRed(&rhsR, green: &rhsG, blue: &rhsB, alpha: &rhsA)
    return lhsR == rhsR && lhsG == rhsG && lhsB == rhsB && lhsA == rhsA
  }
}
