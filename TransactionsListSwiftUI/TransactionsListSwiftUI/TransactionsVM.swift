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
    var transactionsArray = [TransactionModel]()
    
    func getTransactions() async {
        do {
            let data = try await TransactionsApi.fetchTransactions()
            transactionsArray = data
            print(transactionsArray.count)
            transactionsArrayTransformed = convertModel(transactionsModel: transactionsArray)
            transactionsArrayTransformed = transactionsArrayTransformed.sorted {$0.date > $1.date }
            print(transactionsArrayTransformed.count)
            transactionsArrayTransformed = removeSameIdTransactions(transactions: transactionsArrayTransformed)
            print(transactionsArrayTransformed.count)
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

}
