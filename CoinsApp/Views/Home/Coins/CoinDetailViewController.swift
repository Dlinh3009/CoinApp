//
//  CoinDetailViewController.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 19/7/24.
//

import UIKit

class CoinDetailViewController: UIViewController {
    
    var coin: Coin?
    
    let nameLabel = UILabel()
    let symbolTitleLabel = UILabel()
    let symbolValueLabel = UILabel()
    let priceTitleLabel = UILabel()
    let priceValueLabel = UILabel()
    let highTitleLabel = UILabel()
    let highValueLabel = UILabel()
    let lowTitleLabel = UILabel()
    let lowValueLabel = UILabel()
    let priceChangeTitleLabel = UILabel()
    let priceChangeValueLabel = UILabel()
    let marketCapTitleLabel = UILabel()
    let marketCapValueLabel = UILabel()
    let marketCapRankTitleLabel = UILabel()
    let marketCapRankValueLabel = UILabel()
    let totalSupplyTitleLabel = UILabel()
    let totalSupplyValueLabel = UILabel()
    let totalVolumeTitleLabel = UILabel()
    let totalVolumeValueLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(currencyDidChange), name: .currencyDidChange, object: nil)
        displayCoinDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.tintColor = .customGreen
    }
    
    @objc func currencyDidChange() {
        displayCoinDetails()
    }
    
    
    func setupUI() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            createDetailRow(titleLabel: symbolTitleLabel, valueLabel: symbolValueLabel),
            createDetailRow(titleLabel: priceTitleLabel, valueLabel: priceValueLabel),
            createDetailRow(titleLabel: highTitleLabel, valueLabel: highValueLabel),
            createDetailRow(titleLabel: lowTitleLabel, valueLabel: lowValueLabel),
            createDetailRow(titleLabel: priceChangeTitleLabel, valueLabel: priceChangeValueLabel),
            createDetailRow(titleLabel: marketCapTitleLabel, valueLabel: marketCapValueLabel),
            createDetailRow(titleLabel: marketCapRankTitleLabel, valueLabel: marketCapRankValueLabel),
            createDetailRow(titleLabel: totalSupplyTitleLabel, valueLabel: totalSupplyValueLabel),
            createDetailRow(titleLabel: totalVolumeTitleLabel, valueLabel: totalVolumeValueLabel)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func createDetailRow(titleLabel: UILabel, valueLabel: UILabel) -> UIStackView {
        titleLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
        return stackView
    }
    
    func displayCoinDetails() {
        guard let coin = coin else { return }
        
        nameLabel.text = coin.name
        nameLabel.textColor = .customGreen
        symbolTitleLabel.text = "Viết tắt:"
        symbolValueLabel.text = coin.symbol
        priceTitleLabel.text = "Giá hiện tại:"
        priceValueLabel.text = "\(CurrencyManager.shared.currency)\(coin.formatNumber(coin.current_price))"
        highTitleLabel.text = "Giá cao nhất trong 24h:"
        highValueLabel.text = "\(CurrencyManager.shared.currency)\(coin.formatNumber(coin.high_24h))"
        lowTitleLabel.text = "Giá thấp nhất trong 24h:"
        lowValueLabel.text = "\(CurrencyManager.shared.currency)\(coin.formatNumber(coin.low_24h))"
        priceChangeTitleLabel.text = "Giá biến động 24h:"
        priceChangeValueLabel.text = "\(CurrencyManager.shared.currency)\(coin.formatNumber(coin.price_change_24h))"
        marketCapTitleLabel.text = "Tổng vốn hóa thị trường:"
        marketCapValueLabel.text = "\(CurrencyManager.shared.currency)\(coin.formatNumber(coin.market_cap))"
        marketCapRankTitleLabel.text = "Thứ hạng theo vốn hóa:"
        marketCapRankValueLabel.text = "\(coin.formatNumber(coin.market_cap_rank))"
        totalSupplyTitleLabel.text = "Số lượng đang lưu hành:"
        totalSupplyValueLabel.text = "\(coin.formatNumber(coin.total_supply ?? 0))"
        totalVolumeTitleLabel.text = "Khối lượng giao dịch:"
        totalVolumeValueLabel.text = "\(coin.formatNumber(coin.total_volume))"
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .currencyDidChange, object: nil)
    }
}
