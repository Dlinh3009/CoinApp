//
//  OrdersViewController.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 19/7/24.
//

import UIKit

class CoinsViewController: UIViewController {
    
    let filterStackView = UIStackView()

    let priceFilterButton = UIButton()
    let rankFilterButton = UIButton()
    
    var categoryCollectionView: UICollectionView!
    var categoryCollectionViewHeightConstraint: NSLayoutConstraint!
    var isPriceFilterOpen = false
    var isRankFilterOpen = false

    
    var tableView: UITableView!
    var coins: [Coin] = []
    var filteredCoins: [Coin] = []
    var searchString: String = "" {
        didSet {
            filterCoins()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFilterStackView()
        setupCategoryCollectionView()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(currencyDidChange), name: .currencyDidChange, object: nil)
        fetchData()
    }
    
    @objc func currencyDidChange() {
        fetchData()
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self, name: .currencyDidChange, object: nil)
        }
    
    // 2 nút để toggle ra filter
    func setUpFilterStackView() {
        filterStackView.axis = .horizontal
        filterStackView.spacing = 5
        filterStackView.distribution = .fillProportionally

        filterStackView.addArrangedSubview(priceFilterButton)
        filterStackView.addArrangedSubview(rankFilterButton)
        
        createButton(priceFilterButton, title: "Giá coin")
        createButton(rankFilterButton, title: "Thứ hạng")
        
        view.addSubview(filterStackView)
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            filterStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        priceFilterButton.addTarget(self, action: #selector(handlePriceButtonTap(_:)), for: .touchUpInside)
        rankFilterButton.addTarget(self, action: #selector(handleRankButtonTap(_:)), for: .touchUpInside)

    }
    
    func createButton(_ button: UIButton, title: String) {
        updateButtonTitleWithArrow(button, title: title, isOpen: false)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
    func updateButtonTitleWithArrow(_ button: UIButton, title: String, isOpen: Bool) {
        let arrow = isOpen ? "↓" : "→"
        button.setTitle("\(title) \(arrow)", for: .normal)
    }
    
    @objc func handlePriceButtonTap(_ sender: UIButton) {
        isPriceFilterOpen.toggle()
        isRankFilterOpen = false
        categoryCollectionView.isHidden = !isPriceFilterOpen
        categoryCollectionViewHeightConstraint.constant = isPriceFilterOpen ? 30 : 0
        
        updateButtonTitleWithArrow(priceFilterButton, title: "Giá coin", isOpen: isPriceFilterOpen)
        updateButtonTitleWithArrow(rankFilterButton, title: "Thứ hạng", isOpen: isRankFilterOpen)
        
        categoryCollectionView.reloadData()
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleRankButtonTap(_ sender: UIButton) {
        isRankFilterOpen.toggle()
        isPriceFilterOpen = false
        categoryCollectionView.isHidden = !isRankFilterOpen
        categoryCollectionViewHeightConstraint.constant = isRankFilterOpen ? 30 : 0
        
        updateButtonTitleWithArrow(rankFilterButton, title: "Thứ hạng", isOpen: isRankFilterOpen)
        updateButtonTitleWithArrow(priceFilterButton, title: "Giá coin", isOpen: isPriceFilterOpen)

        categoryCollectionView.reloadData()
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    // Table view chứa các cell về coins
    func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear 
        tableView.register(UINib(nibName: "CoinTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinTableViewCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
    }
    
    func setupCategoryCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        categoryCollectionView.isHidden = false
        
        view.addSubview(categoryCollectionView)
        
        addSeparator()
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        categoryCollectionViewHeightConstraint = categoryCollectionView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 10),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            categoryCollectionViewHeightConstraint
        ])
    }
    func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 3),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
        
        if let lastSubview = view.subviews.dropLast().last {
            separator.topAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 5).isActive = true
        } else {
            separator.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        }
    }
    
    func fetchData() {
        APIService.shared.fetchCoins { [weak self] coins in
            guard let self = self, let coins = coins else { return }
            self.coins = coins
            self.filteredCoins = coins
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func filterCoins() {
        if searchString.isEmpty {
            filteredCoins = coins
        } else {
            filteredCoins = coins.filter { $0.name.localizedCaseInsensitiveContains(searchString) }
        }
        tableView.reloadData()
    }
    
}

// CollectionView chứa các thể loại toggle xuống
extension CoinsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPriceFilterOpen {
            return 3
        } else if isRankFilterOpen {
            return 2
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        var titles: [String] = []

        let button = UIButton()
        if isPriceFilterOpen {
            titles = ["Giá cao nhất (10)", "Giá thấp nhất (10)", "Biến động nhiều nhất"]
        } else if isRankFilterOpen {
            titles = ["Tăng dần", "Giảm dần"]
        }

        button.setTitle(titles[indexPath.item], for: .normal)
        button.setTitleColor(.customGreen, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.customGreen.cgColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.tag = indexPath.item
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
                

        cell.contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            button.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor),
            button.heightAnchor.constraint(equalToConstant: 20)
        ])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 30)
    }
    
    @objc func filterButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        if isPriceFilterOpen {
            switch index {
            case 0:
                // Giá cao nhất (10)
                filteredCoins = coins.sorted { (coin1: Coin, coin2: Coin) -> Bool in
                    return coin1.current_price > coin2.current_price
                }.prefix(10).map { $0 }
            case 1:
                // Giá thấp nhất (10)
                filteredCoins = coins.sorted { (coin1: Coin, coin2: Coin) -> Bool in
                    return coin1.current_price < coin2.current_price
                }.prefix(10).map { $0 }
            case 2:
                // Biến động nhiều nhất
                filteredCoins = coins.sorted { (coin1: Coin, coin2: Coin) -> Bool in
                    return abs(coin1.price_change_24h) > abs(coin2.price_change_24h)
                }
            default:
                break
            }
        } else if isRankFilterOpen {
            switch index {
            case 0:
                // Thứ hạng tăng dần theo vốn hóa
                filteredCoins = coins.sorted { (coin1: Coin, coin2: Coin) -> Bool in
                    return coin1.market_cap_rank > coin2.market_cap_rank
                }
            case 1:
                // Thứ hạng giảm dần theo vốn hóa
                filteredCoins = coins.sorted { (coin1: Coin, coin2: Coin) -> Bool in
                    return coin1.market_cap_rank < coin2.market_cap_rank
                }
            default:
                break
            }
        }
        tableView.reloadData()
    }

}

extension CoinsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell", for: indexPath) as! CoinTableViewCell
        let coin = filteredCoins[indexPath.row]
        cell.configure(data: coin)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoin = filteredCoins[indexPath.row]
        let coinDetailVC = CoinDetailViewController()
        coinDetailVC.coin = selectedCoin
        navigationController?.pushViewController(coinDetailVC, animated: false)
    }
    
}


