//
//  ContentView.swift
//  TransactionsListSwiftUI
//
//  Created by Alejandro Arce on 24/3/23.
//

import SwiftUI

struct TransactionstView: View {
    @StateObject var transactionsVM = TransactionsVM()
    var body: some View {
        NavigationView{
            List(transactionsVM.transactionsArrayTransformed,id: \.id) { transaction in
                HStack(alignment: .center){
                    Text(String(transaction.date.formatted(date: .numeric, time: .omitted)))
                    Spacer()
                    Text(String("\(transaction.totalAmount) €"))
                    Spacer()
                    if transaction.amount < 0 {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await transactionsVM.getTransactions()
            }
        }
    }
}

