//
//  TransactionDetailView.swift
//  TransactionsListSwiftUI
//
//  Created by Alejandro Arce on 3/4/23.
//

import SwiftUI

struct TransactionDetailView: View {
    var amount: Double
    var fee: Double
    var description: String
    var totalAmount: Double
    var body: some View {
        VStack{
            Text(String(amount))
            Text(String(fee))
            Text(description)
            Text(String(totalAmount))
        }
    }
}


