//
//  Item.swift
//  Finny
//
//  Created by Dennis Dang on 5/5/24.
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
