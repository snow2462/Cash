//
//  UserFinance.swift
//  Money
//
//  Created by Kiem To on 8/25/23.
//

import Foundation
import RealmSwift

class UserFinanceEntity: Object {
        @objc dynamic var id = 1
    @objc dynamic var balance : String = ""
    @objc dynamic var transactionsAmount : Double = 0
    @objc dynamic var transactionsTitle : String = ""
    @objc dynamic var transactionsId : String = ""
    @objc dynamic var transactionsCurrency : String = ""

}
