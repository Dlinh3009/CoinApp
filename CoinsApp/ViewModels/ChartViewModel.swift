//
//  ChartViewModel.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 26/7/24.
//

import Charts

class ChartViewModel {
    var coins: [Coin] = []
    var filteredCoins: [Coin] = []
    var updateChart: (([[Double]], String) -> Void)?
    var updateTableView: ((Bool) -> Void)?
    var showAlert: ((String, String) -> Void)?
    var isSearching = false
    
    // Lấy coin gợi ý theo từ khóa ở textfield
    func fetchSuggestion() {
        APIService.shared.fetchCoins { [weak self] coins in
            guard let self = self, let coins = coins else { return }
            self.coins = coins
            self.filteredCoins = coins
            self.updateTableView?(self.isSearching)
        }
    }
    
    // Lấy giá coin
    func fetchMarketChart(for coinName: String) {
        APIService.shared.fetchMarketChart(for: coinName) { [weak self] marketChart, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let marketChart = marketChart {
                    self.updateChart?(marketChart.prices, coinName)
                } else {
                    self.showAlert?("Lỗi", "Coin không tồn tại hoặc không có dữ liệu.")
                }
            }
        }
    }
    
    // Lọc coin theo từ khóa ở textfield
    func filterCoins(searchString: String) {
        if !searchString.isEmpty {
            filteredCoins = coins.filter { $0.name.localizedCaseInsensitiveContains(searchString) }
            isSearching = true
        }
        else {
            filteredCoins.removeAll()
            isSearching = false
        }
        updateTableView?(isSearching)
    }
}
