//
//  APIService.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 19/7/24.
//

import Foundation
import Alamofire

class APIService {
    static let shared = APIService()
    
    private var currency: String {
        switch CurrencyManager.shared.currency {
        case "€": 
            return "eur"
        case "₫": 
            return "vnd"
        default: 
            return "usd"
        }
    }   
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(currencyDidChange), name: .currencyDidChange, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .currencyDidChange, object: nil)
    }
    
    @objc private func currencyDidChange() {
    }
    
    func fetchCoins(completion: @escaping ([Coin]?) -> Void) {
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(currency)&precision=2&?x_cg_demo_api_key=CG-y24YYJjrBuaFegwPUzTiVb29"
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print("Response JSON: \(json)")
                    }
                    let coins = try JSONDecoder().decode([Coin].self, from: data)
                    completion(coins)
                } catch let jsonError {
                    print("Failed to decode JSON:", jsonError)
                    completion(nil)
                }
            case .failure(let error):
                print("Failed to fetch coins:", error)
                completion(nil)
            }
        }
    }
    
    func fetchMarketChart(for coinName: String, completion: @escaping (PriceChart?, Error?) -> Void) {
        let url = "https://api.coingecko.com/api/v3/coins/\(coinName)/market_chart?vs_currency=\(currency)&days=7&interval=daily&precision=2&?x_cg_demo_api_key=CG-y24YYJjrBuaFegwPUzTiVb29"
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print("Response JSON: \(json)")
                    }
                    let marketChart = try JSONDecoder().decode(PriceChart.self, from: data)
                    completion(marketChart, nil)
                } catch let jsonError {
                    print("Failed to decode JSON:", jsonError)
                    completion(nil, jsonError)
                }
            case .failure(let error):
                print("Failed to fetch market chart:", error)
                completion(nil, error)
            }
        }
    }
    
}
