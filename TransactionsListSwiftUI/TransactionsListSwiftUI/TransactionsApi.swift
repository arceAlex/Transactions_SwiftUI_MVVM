//
//  TransactionsApi.swift
//  TransactionsListSwiftUI
//
//  Created by Alejandro Arce on 24/3/23.
//

import Foundation

enum JsonError: Error {
    case decodingError
    case codeError
    case defaulError
    case invalidUrl
}

class TransactionsApi {
    static func fetchTransactions() async throws -> [TransactionModel] {
        guard let url = URL(string: "https://code-challenge-e9f47.web.app/transactions.json") else {
            throw JsonError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw JsonError.defaulError
        }
        if httpResponse.statusCode != 200 {
            throw JsonError.codeError
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([TransactionModel].self, from: data)
        } catch {
            throw JsonError.decodingError
        }
    }
}
