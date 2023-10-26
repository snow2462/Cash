//
//  RealmManager.swift
//  Money
//
//  Created by Kiem To on 8/25/23.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published var transaction: [TransactionData] = []
    @Published var balance: String = ""

    init() {
        openRealm()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion > 1 {
                    // Do something, usually updating the schema's variables here
                }
            })

            Realm.Configuration.defaultConfiguration = config

            localRealm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }
    
    func addFinance(balance: String, data: [TransactionData]) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    if !localRealm.isEmpty {
                        localRealm.deleteAll()
                    }

                    data.forEach{item in
                        let newData = UserFinanceEntity()
                        newData.balance = balance
                        newData.transactionsAmount = item.amount
                        newData.transactionsTitle = item.title
                        newData.transactionsId = item.id
                        newData.transactionsCurrency = item.currency
                        localRealm.add(newData)
                    }
                   
                    print("Added new balance to Realm!")
                }
            } catch {
                print("Error adding course to Realm", error)
            }
        }
    }
    
    func getFinance() {
        if let localRealm = localRealm {
            let allTransactions = localRealm.objects(UserFinanceEntity.self)
            if allTransactions.isEmpty {
                return
            }
            balance = allTransactions.first!.balance
            allTransactions.forEach { item in
                let double = Double(item.transactionsAmount)
                let object = TransactionData(title: item.transactionsTitle, id: item.transactionsId, currency: item.transactionsCurrency, amount: double)
            transaction.append(object)
                }
            }
        
    }
}
