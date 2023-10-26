//
//  Transaction.swift
//  Money
//
//  Created by Kiem To on 8/24/23.
//

import Foundation
import RealmSwift

struct Transaction: Codable {
    var total, count: Int
    var data : [TransactionData]
    var last : Bool

    enum CodingKeys: String, CodingKey {
case total, count, last, data
    }
}

struct TransactionData: Codable {
    var title: String
    var amount : Double
    var currency: String
    var id : String
    
    enum CodingKeys: String, CodingKey {
case title, amount, currency, id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(id, forKey: .id)
        try container.encode(currency, forKey: .currency)
        try container.encode(amount, forKey: .amount)

    }
    
    init(title: String, id: String, currency: String, amount: Double) {
            self.title = title
            self.id = id
            self.currency = currency
            self.amount = amount
        }
}

