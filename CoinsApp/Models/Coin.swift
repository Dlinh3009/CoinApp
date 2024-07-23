//
//  Coin.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 19/7/24.
//

import Foundation

struct Coin: Codable {
    let name: String
    let symbol: String
    let current_price: Double
    let high_24h: Double
    let low_24h: Double
    let price_change_24h: Double
    let market_cap: Double
    let market_cap_rank: Double 
    let total_supply: Double
    let total_volume: Double
    let image: String
}

struct PriceChart: Codable {
    let prices: [[Double]]
}
