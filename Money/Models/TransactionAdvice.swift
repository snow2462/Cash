//
//  TransactionAdivce.swift
//  Money
//
//  Created by Kiem To on 8/24/23.
//

import Foundation

struct TransactionAdvice: Codable {
    var title: String
    var description : String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
    }
}
