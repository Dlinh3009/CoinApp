//
//  CurrencyManager.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 25/7/24.
//

import Foundation

// Theo dõi và thay đổi đơn vị tiền tệ để update UI
class CurrencyManager {
    static let shared = CurrencyManager()
    
    var currency: String {
        switch UserDefaults.standard.integer(forKey: "currencyIndex") {
        case 1:
            return "€"
        case 2:
            return "₫"
        default:
            return "$"
        }
    }
    
    private init() {}
    
    func updateCurrency() {
        NotificationCenter.default.post(name: .currencyDidChange, object: nil)
    }
}

extension Notification.Name {
    static let currencyDidChange = Notification.Name("currencyDidChange")
}

