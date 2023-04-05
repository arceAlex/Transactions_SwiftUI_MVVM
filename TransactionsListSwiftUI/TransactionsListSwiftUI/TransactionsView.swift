//
//  ContentView.swift
//  TransactionsListSwiftUI
//
//  Created by Alejandro Arce on 24/3/23.
//

import SwiftUI

struct TransactionsView: View {
    @StateObject var transactionsVM = TransactionsVM()
    @State var didLoad: Bool = false
    var body: some View {
        NavigationView{
            VStack{
                List(transactionsVM.transactionsArrayTransformed,id: \.id) { transaction in
                    NavigationLink(destination: TransactionDetailView(amount: transaction.amount, fee: transaction.fee ?? 0, description: transaction.description ?? "No description", totalAmount: transaction.totalAmount)){
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
                if didLoad == false {
                    await transactionsVM.getTransactions()
                    didLoad = true
                }
            }
        }
    }
}

