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
            VStack{
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
                Spacer()
                ZStack {
                    List {
                        HStack {
                            Text("  Balance:")
                                .bold()
                            Spacer()
                            Text("\(transactionsVM.accountBalanceStr) €")
                                .bold()
                            Spacer()
                            if transactionsVM.positiveBalance == false {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.red)
                            } else {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .scrollDisabled(true)
                }
                .frame(height: 90)
            }
            .background(Color.gray.opacity(0.112))
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await transactionsVM.getTransactions()
            }
        }
    }
}

