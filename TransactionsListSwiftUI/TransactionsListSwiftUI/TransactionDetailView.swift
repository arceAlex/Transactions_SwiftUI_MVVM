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
        VStack(alignment: .leading){
            Text(description)
                .font(.title)
                .bold()
            Text("Amount: \(String(amount)) €")
                .font(.title2)
            Text("Fee: \(String(fee)) €")
                .font(.title2)
            Text("Total: \(String(totalAmount)) €")
                .font(.title2)
        }
        .padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(amount: 24, fee: -12, description: "Hi, this is the description of my transaction", totalAmount: 12)
    }
}
