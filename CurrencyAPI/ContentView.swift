//
//  ContentView.swift
//  CurrencyAPI
//
//  Created by Najd on 28/09/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var currencies = CurrencyState.currencies
    
    @State var amount: String = "0.0"
    @State var convertedAmount: String? = nil
    @State var fromCurrency: Currency = CurrencyState.currencies[0]
    @State var toCurrency: Currency = CurrencyState.currencies[1]
    
    @State var isLoading = false
    
    @ObservedObject var errorDelegate = ExchangeRateDelegate()
    
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.decimalSeparator = "."
        
        return formatter
    }
    

    var body: some View {
        VStack(spacing: 20){
            Text("Currency Converter")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.appColor).padding()
            
            Image("currency-exchange").resizable().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
            
            Text("Your Converted Amount").font(.title3)
            
            HStack{
                if isLoading{
                    ProgressView()
                } else{
                    Text(getConvertedAmountString()).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(.white)
                    
                }
            }.frame(width: 350, height: 80)
                .background(Color.appColor)
                .cornerRadius(12)
            
            VStack(alignment: .leading){
                Text("Convert Amount").font(.title3).padding()
                
                TextField("", text: $amount)
                    .font(.system(size: 22))
                    .padding(10).frame(width: 350, height: 50)
                    .background(.gray.opacity(0.2)).cornerRadius(12)
                
            }
            
            HStack{
                Text("From currency")
                
                Spacer()
                
                Picker("From currency", selection: $fromCurrency) {
                    ForEach(currencies, id: \.code){cur in
                        Text(cur.code).tag(cur)
                    }
                }
            }
            
            HStack{
                Text("To currency")
                
                Spacer()
                
                Picker("To currency", selection: $toCurrency) {
                    ForEach(currencies, id: \.code){cur in
                        Text(cur.code).tag(cur)
                    }
                }
            }
            
            Button(action: {
                convertCurrency()
            }, label: {
                Text("Convert").frame(width: 350, height: 50)
                    .foregroundColor(.white).background(Color.blue)
                    .cornerRadius(12)
            })
            
            
            
        }
        .padding(.top, 30).padding(.leading, 30).padding(.trailing, 30).padding(.bottom, 30)
    }
    
    func getConvertedAmountString()-> String{
        return convertedAmount ?? "\(fromCurrency.symbol) \(amount)"
    }
    
    func convertCurrency() -> Void{
        guard let floatAmount = formatter.number(from: amount) as? Float else{return}
        
        isLoading = true
        
        DispatchQueue.global(qos: .background).async {
            let rateManager = ExchangeRateManager()
            rateManager.delegate = errorDelegate
            rateManager.fetchRate(for: fromCurrency.code, toCurrency: toCurrency.code) { result in
                
                if let exchangeRate = result{
                    let convertedAmountF = exchangeRate.rate * floatAmount
                    let convertedAmountString = formatter.string(from: NSNumber(value: convertedAmountF)) ?? "0.0"
                    
                    DispatchQueue.main.async {
                        isLoading = false
                        self.convertedAmount = "\(toCurrency.symbol) \(convertedAmountString)"
                        
                    }
                }
            }
            
        }
        
    }

}

#Preview {
    ContentView()
}
