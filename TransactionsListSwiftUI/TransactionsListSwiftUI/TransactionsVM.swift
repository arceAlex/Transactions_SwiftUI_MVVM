//
//  TransactionsVM.swift
//  TransactionsListSwiftUI
//
//  Created by Alejandro Arce on 24/3/23.
//

import Foundation
import SwiftUI

@MainActor
class TransactionsVM : ObservableObject {
    @Published var transactionsArrayTransformed = [TransactionModelTransformed]()
    @Published var accountBalanceStr : String = ""
    var transactionsArray = [TransactionModel]()
    
    func getTransactions() async {
        do {
            let data = try await TransactionsApi.fetchTransactions()
            transactionsArray = data
            transactionsArrayTransformed = convertModel(transactionsModel: transactionsArray)
            transactionsArrayTransformed = transactionsArrayTransformed.sorted {$0.date > $1.date }
            transactionsArrayTransformed = removeSameIdTransactions(transactions: transactionsArrayTransformed)
            getBalance(transactions: transactionsArrayTransformed)
        } catch JsonError.decodingError {
            print("Decoding Error")
        } catch JsonError.codeError {
            print("Code Error")
        } catch JsonError.invalidUrl {
            print("Invalid URL")
        } catch {
            print(error.localizedDescription)
        }
    }
            //Transform the model from the Json into another model with the date in Date type, and removing transactions with incorrect date format.
    private func convertModel(transactionsModel: [TransactionModel]) -> [TransactionModelTransformed] {
        var arrayTransformed = transactionsArrayTransformed
        
        for transaction in transactionsModel   {
            if let date = convertStringToDate(strDate: transaction.date) {
                arrayTransformed.append(TransactionModelTransformed(id: transaction.id, date: date, amount: transaction.amount, fee: transaction.fee, description: transaction.description))
            } else {
                continue
            }
        }
        return arrayTransformed
    }
             //Remove transactions with the same id, displaying only the most recent one.
    private func removeSameIdTransactions(transactions: [TransactionModelTransformed]) -> [TransactionModelTransformed] {
        var transactionsNoRepitedId = transactions
        var ids : [Int] = []
        
        for (index, transaction) in transactionsNoRepitedId.enumerated() {
            if ids.contains(transaction.id) {
                transactionsNoRepitedId.remove(at: index)
            }
            ids.append(transaction.id)
        }
        return transactionsNoRepitedId
    }
    
    private func convertStringToDate(strDate: String) -> Date? {
        let dateString = strDate
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }
    private func getBalance(transactions: [TransactionModelTransformed]){
        var accountBalance : Double = 0
        for transaction in transactions {
            accountBalance += transaction.amount
        }
        accountBalanceStr = String(format: "%.2f", accountBalance)
    }

}
