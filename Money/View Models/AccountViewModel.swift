//
//  AccountViewModel.swift
//  Money
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import Foundation
import Combine

@MainActor class AccountViewModel: ObservableObject {
    @Published private(set) var isBusy = false
    @Published private(set) var accountBalance: String = "-"
    @Published private(set) var transactionAdviceDescription: String = ""
    @Published private(set) var transactionAdviceTitle: String = ""
    @Published private(set) var transactionList:  [TransactionData] = []
    @Published private(set) var isPaidUser:  Bool = false

    private let moneyService = MoneyService()
    private let realmManager = RealmManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        moneyService.isBusy
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isBusy in
                self?.isBusy = isBusy
            }
            .store(in: &cancellables)
    }

    func fetchAccountData() async {
        let reachability = try! Reachability()

        if reachability.connection == .unavailable{
            fetchLocalData()
            return
        }
        // get account balance
        guard let account = await moneyService.getAccount() else { return }
        
        // get account transaction
        guard let transaction = await moneyService.getTransactions() else { return }
        let balance = account.balance.formatted(.currency(code: account.currency))
        let data = transaction.data
        assignData(balance: balance, data: data)
        saveToLocalData()

        if getIsPaidUserStatus() {
            await fetchAccountAdvice()
        }
    }
    
    func fetchAccountAdvice() async {
            guard let advice = await moneyService.getTransactionAdice(transactions: transactionList) else { return }
           transactionAdviceTitle = advice.title
           transactionAdviceDescription = advice.description
    }
    
    func assignData(balance: String, data: [TransactionData]){
        accountBalance = balance
        transactionList = data
    }
    
    func fetchLocalData() {
        realmManager.getFinance();
        assignData(balance: realmManager.balance, data: realmManager.transaction)
    }
    
    func saveToLocalData(){
        realmManager.addFinance(balance: accountBalance, data: transactionList)
    }
    
    func getIsPaidUserStatus() -> Bool{
        return UserDefaults.standard.bool(forKey: "isPaidUser")
    }
    
    func setPaidUserDefault(){
        UserDefaults.standard.set(true, forKey: "isPaidUser")
    }
}
