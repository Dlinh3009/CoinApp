//
//  CoinsViewModel.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 26/7/24.
//

import Foundation

class CoinsViewModel {
    var coins: [Coin] = []
    var filteredCoins: [Coin] = []
    var updateTableView: (() -> Void)?
    var searchString: String = "" {
        didSet {
            filterCoins()
        }
    }
    var isPriceFilterOpen = false
    var isRankFilterOpen = false
    var selectedFilterIndex: Int?
    
    // Lấy coin
    func fetchData() {
        APIService.shared.fetchCoins { [weak self] coins in
            guard let self = self, let coins = coins else { return }
            self.coins = coins
            self.filteredCoins = coins
            DispatchQueue.main.async {
                self.updateTableView?()
            }
        }
    }
    
    // Lọc coin theo từ khóa
    func filterCoins() {
        if searchString.isEmpty {
            filteredCoins = coins
        } else {
            filteredCoins = coins.filter { $0.name.localizedCaseInsensitiveContains(searchString) }
        }
        updateTableView?()
    }
    
    // Sắp xếp coin
    func filterButtonTapped(index: Int) {
        if selectedFilterIndex == index {
            filteredCoins = coins
            selectedFilterIndex = nil
        } else {
            selectedFilterIndex = index
            if isPriceFilterOpen {
                switch index {
                case 0:
                    filteredCoins = coins.sorted { $0.current_price > $1.current_price }.prefix(10).map { $0 }
                case 1:
                    filteredCoins = coins.sorted { $0.current_price < $1.current_price }.prefix(10).map { $0 }
                case 2:
                    filteredCoins = coins.sorted { abs($0.price_change_24h) > abs($1.price_change_24h) }
                default:
                    break
                }
            } else if isRankFilterOpen {
                switch index {
                case 0:
                    filteredCoins = coins.sorted { $0.market_cap_rank > $1.market_cap_rank }
                case 1:
                    filteredCoins = coins.sorted { $0.market_cap_rank < $1.market_cap_rank }
                default:
                    break
                }
            }
        }
        updateTableView?()
    }
}
