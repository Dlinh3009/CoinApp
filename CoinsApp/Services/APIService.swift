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

    func fetchCoins(completion: @escaping ([Coin]?) -> Void) {
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&precision=2"
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
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
        let url = "https://api.coingecko.com/api/v3/coins/\(coinName)/market_chart?vs_currency=usd&days=7&interval=daily&precision=2"

        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
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


