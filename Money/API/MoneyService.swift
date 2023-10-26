//
//  MoneyService.swift
//  Money
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import Foundation
import Combine

protocol MoneyServiceProtocol {
    var isBusy: AnyPublisher<Bool, Never> { get }

    func getAccount() async -> Account?
    
    func getTransactions() async -> Transaction?
    
    func getTransactionAdice(transactions: [TransactionData]) async -> TransactionAdvice?
}

class MoneyService: MoneyServiceProtocol {
    
    
    private let _isBusy = PassthroughSubject<Bool, Never>()
    lazy private(set) var isBusy = _isBusy.eraseToAnyPublisher()
    
    private static let serviceBaseURL = URL(string: "https://8kq890lk50.execute-api.us-east-1.amazonaws.com/prd/accounts/0172bd23-c0da-47d0-a4e0-53a3ad40828f")!
    private let session = URLSession.shared
    
    func getAccount() async -> Account? {
        await getData("balance")
    }
    
    func getTransactions() async -> Transaction? {
        await getData("transactions")
    }

    func getTransactionAdice(transactions: [TransactionData]) async -> TransactionAdvice? {
        await getAdvice(transactions: transactions)
    }
    private func getData<T: Codable>(_ endpoint: String) async -> T? {
        _isBusy.send(true)
        defer { _isBusy.send(false) }
        
        let dataURL = Self.serviceBaseURL.appending(component: endpoint)
        
        do {
            let (data, _) = try await session.data(from: dataURL)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Error getting data from \(endpoint): \(error)")
        }
        
        return nil
    }
    
    private func getAdvice<T: Codable>(transactions: [TransactionData]) async -> T? {
        _isBusy.send(true)
        defer { _isBusy.send(false) }
        
        // Prepare Json Data
        var transactionIdList = [String]()
        transactions.forEach{item in
            transactionIdList.append(item.id)
        }
        let json: [String: Any] = ["transactionIds": transactionIdList];
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // Create Post request
        let endpoint = URL(string: "https://8kq890lk50.execute-api.us-east-1.amazonaws.com/prd/accounts/0172bd23-c0da-47d0-a4e0-53a3ad40828f/transactions/advice")!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Error getting data from \(endpoint): \(error)")
        }
        
        return nil
    }
}
