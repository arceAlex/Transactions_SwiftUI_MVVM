//
//  TransactionModel.swift
//  TransactionsListSwiftUI
//
//  Created by Alejandro Arce on 24/3/23.
//

import Foundation

struct TransactionModel : Decodable {
    let id: Int
    let date: String
    let amount: Double
    let fee: Double?
    let description: String?
}

struct TransactionModelTransformed {
    let id: Int
    let date: Date
    let amount: Double
    let fee: Double?
    let description: String?
    var totalAmount : Double {
        if let fee = fee {
            return abs(amount + fee)
        } else {
            return abs(amount)
        }
    }
}
