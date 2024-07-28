//
//  CoinTableViewCell.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 22/7/24.
//

import UIKit
import SDWebImage

class CoinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var highestLabel: UILabel!
    @IBOutlet weak var lowestLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    @IBAction func copyButton(_ sender: Any) {
        copyCellContent()
        showToastNotification()
    }
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.layer.cornerRadius = 20
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalTo: avatar.widthAnchor)
        ])
        
        contentView.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    
    func configure(data coin: Coin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        currentLabel.text = "Giá hiện tại: \(CurrencyManager.shared.currency)\(coin.formatNumber(coin.current_price))"
        highestLabel.text = "Giá cao nhất (24h): \(CurrencyManager.shared.currency)\(coin.formatNumber(coin.high_24h))"
        lowestLabel.text = "Giá thấp nhất (24h): \(CurrencyManager.shared.currency)\(coin.formatNumber(coin.low_24h))"
        changeLabel.text = "Biến động (24h): \(CurrencyManager.shared.currency)\(coin.formatNumber(coin.price_change_24h))"
        
        if let avatarUrl = URL(string: coin.image) {
            avatar.sd_setImage(with: avatarUrl, placeholderImage: UIImage(systemName: "person.circle"))
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func copyCellContent() {
        let contentToCopy = """
            Tên coin: \(nameLabel.text ?? "")
            Viết tắt: \(symbolLabel.text ?? "")
            \(currentLabel.text ?? "")
            \(highestLabel.text ?? "")
            \(lowestLabel.text ?? "")
            \(changeLabel.text ?? "")
            """
        UIPasteboard.general.string = contentToCopy
    }
    private func showToastNotification() {
        if let viewController = self.window?.rootViewController {
            viewController.showToast(message: "Đã sao chép", duration: 1.0)
        }
    }
}



