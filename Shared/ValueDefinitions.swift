//
//  ValueDefinitions.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 3/27/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import Foundation
import SwiftUI


let FibonacciCardValues = ["0", "1", "2", "3", "5", "8", "13", "21", "34", "55", "89"]
let FibonacciDeckName = "Fibonacci"

let FibonacciHalfPointCardValues = ["0", "0.5", "1", "2", "3", "5", "8", "13", "20", "40", "100", "?", "☕️", "♾"]
let FibonnaciHalfPointDeckName = "Fibonacci Half Point"

let PlayingCardValues = ["A", "2", "3", "5", "8", "K"]
let PlayingCardDeckName = "Playing Cards"


let DefualtCardColor = "Blue"
let DefualtCardFontColor = "White"
let CardColors: [String: Color] = ["Blue": .blue, "Gray": .gray, "Green": .green, "Orange": .orange, "Pink": .pink, "Red": .red, "Yellow": .yellow]
let CardFontColors: [String: Color] = ["Black": .black, "White": .white]
let LocalizedColorNames: [String: String] = ["Blue": NSLocalizedString("Blue", comment: ""),
                                             "Gray": NSLocalizedString("Gray", comment: ""),
                                             "Green": NSLocalizedString("Green", comment: ""),
                                             "Orange": NSLocalizedString("Orange", comment: ""),
                                             "Pink": NSLocalizedString("Pink", comment: ""),
                                             "Red": NSLocalizedString("Red", comment: ""),
                                             "Yellow": NSLocalizedString("Yellow", comment: ""),
                                             "Black": NSLocalizedString("Black", comment: ""),
                                             "White": NSLocalizedString("White", comment: "")]
