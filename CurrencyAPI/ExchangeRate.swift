//
//  ExchangeRate.swift
//  CurrencyAPI
//
//  Created by Najd on 28/09/2024.
//

import Foundation

struct ExchangeRate: Codable{
    let from: String
    let to: String
    let rate: Float
    
}

struct ExchangeRateRespones: Codable {
    let data: [String: Float]
    
    
    func toExchangeRate(from: String, to: String) -> ExchangeRate{
        return ExchangeRate(from: from, to: to, rate: data[to] ?? 0.0)
    }
    
}

enum ExchangeRateRequestErrorType{
    case server
    case client
    case decode
}

struct ExchangeRateErrorDetail{
    let error: Error
    let type: ExchangeRateRequestErrorType
}

protocol ExchangeRateResponesDelegate{
    func reset()
    func requestFaildWith(error: Error? , type: ExchangeRateRequestErrorType)
}

class ExchangeRateDelegate: ExchangeRateResponesDelegate, ObservableObject{
    
    @Published var isErrorState: Bool = false
    @Published var errorDetail: ExchangeRateErrorDetail? = nil
    
    
    func reset() {
        DispatchQueue.main.async {
            self.isErrorState = false
            self.errorDetail = nil
        }
    }
    
    func requestFaildWith(error: Error?, type: ExchangeRateRequestErrorType) {
        DispatchQueue.main.async {
            self.isErrorState = true
            if let err = error{
                self.errorDetail = ExchangeRateErrorDetail(error: err, type: type)
            }
            
        }
    }
}
