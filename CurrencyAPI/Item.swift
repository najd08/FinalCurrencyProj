//
//  Item.swift
//  CurrencyAPI
//
//  Created by Najd on 28/09/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
