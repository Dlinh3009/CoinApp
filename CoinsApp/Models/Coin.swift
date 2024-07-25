//
//  Coin.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 19/7/24.
//

import Foundation

struct Coin: Codable {
    let id: String
    let name: String
    let symbol: String
    let current_price: Double
    let high_24h: Double
    let low_24h: Double
    let price_change_24h: Double
    let market_cap: Double
    let market_cap_rank: Double 
    let total_supply: Double?
    let total_volume: Double
    let image: String
    
    func formatNumber(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

struct PriceChart: Codable {
    let prices: [[Double]]
}
