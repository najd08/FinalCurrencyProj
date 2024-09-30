//
//  ExchangeRateManager.swift
//  CurrencyAPI
//
//  Created by Najd on 28/09/2024.
//

import Foundation

class ExchangeRateManager{
    
    public var delegate: ExchangeRateDelegate? = nil
    
    static let apiKey = "fca_live_qEKeaheIrUHMkxcbWrF4QeCjneSvwHwmEgBZnshd"
    
    let Url = "https://api.freecurrencyapi.com/v1/latest?apikey=\(ExchangeRateManager.apiKey)"
    
    func fetchRate(for currency: String, toCurrency:String, completion: @escaping (_ exchangeRate: ExchangeRate? ) -> Void ){
        
        self.delegate?.reset()
        
        let url = URL(string: "\(self.Url)&base_currency=\(currency)&currencies=\(toCurrency)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, respone, error in
            
            if let err = error {
                self.handleClientError(err)
                DispatchQueue.main.async {
                    completion(nil)
                }

                return
            }
            
            guard let httprespones = respone as? HTTPURLResponse, httprespones.statusCode == 200 else {
                self.handleServerError(respone)
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            
            if let mimeType = httprespones.mimeType, mimeType == "application/json",
               let json = data{
                let rate = self.decodeResponse(json: json, for: currency, to: toCurrency)
                
                DispatchQueue.main.async {
                    completion(rate)
                }
            } else {
                // handle decode error
            }
            
            
        }
        task.resume()
    }
    
    func decodeResponse(json: Data , for currency: String, to toCurrency: String)-> ExchangeRate? {
        do{
            let decoder = JSONDecoder()
            let exchangeRateResponse = try decoder.decode(ExchangeRateRespones.self, from: json)
            return exchangeRateResponse.toExchangeRate(from: currency, to: toCurrency)
            
        }catch{
            self.handleDecodeError(error)
            return nil
        }
    }
    
    private func handleClientError(_ error: Error){
        delegate?.requestFaildWith(error: error, type: .client)
    }
    
    private func handleServerError(_ response: URLResponse?){
        let error = NSError(domain: "api error", code: 141)
        delegate?.requestFaildWith(error: error, type: .server)
    }
    
    private func handleDecodeError(_ error: Error){
        delegate?.requestFaildWith(error: error, type: .decode)
    }
    
    
}
