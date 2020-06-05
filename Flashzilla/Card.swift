//
//  Card.swift
//  Flashzilla
//
//  Created by Christopher Walter on 6/3/20.
//  Copyright © 2020 Christopher Walter. All rights reserved.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String

    static var example: Card {
        Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
}
