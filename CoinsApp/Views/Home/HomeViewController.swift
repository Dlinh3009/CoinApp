//
//  HomeViewController.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 19/7/24.
//

import UIKit

class HomeViewController: UIViewController {
    let appLabel = UILabel()
    let tabBar = UITabBarController()
    var searchButton = UIButton()
    let searchBar = UISearchBar()
    var underlineView: UIView?
    var chartViewController: ChartViewController!
    var coinsViewController: CoinsViewController!
    
    var initialSetupDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppLabel()
        addFirstSeparator()
        setupCustomTabBar()
        addSecondSeparator()
        setUpSubViewController()
        setUpSearchBar()
        tabBar.selectedIndex = 1
        initialSetupDone = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if initialSetupDone {
            updateUnderlinePosition()
        }
    }
    
    // Label
    func setUpAppLabel() {
        appLabel.text = "Coins App"
        if let customFont = UIFont(name: "MarkerFelt-Thin", size: 30) {
            appLabel.font = customFont
        } else {
            appLabel.font = .systemFont(ofSize: 30, weight: .bold)
        }
        appLabel.textColor = .customGreen
        view.addSubview(appLabel)
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            appLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            appLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            appLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // 2 ViewController con là Coin và Biểu đồ
    func setUpSubViewController() {
        chartViewController = ChartViewController()
        coinsViewController = CoinsViewController()
        
        addChild(chartViewController)
        view.addSubview(chartViewController.view)
        chartViewController.didMove(toParent: self)
        chartViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(coinsViewController)
        view.addSubview(coinsViewController.view)
        coinsViewController.didMove(toParent: self)
        coinsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chartViewController.view.topAnchor.constraint(equalTo: tabBar.view.bottomAnchor, constant: 10),
            chartViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            chartViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            chartViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            coinsViewController.view.topAnchor.constraint(equalTo: tabBar.view.bottomAnchor, constant: 10),
            coinsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            coinsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            coinsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        
        chartViewController.view.isHidden = true
        coinsViewController.view.isHidden = false
    }
    
    // TabBar để di chuyển giữa Coins và Biểu đồ, kèm them nút tìm kiếm
    func setupCustomTabBar() {
        let coinsViewCOntroller = CoinsViewController()
        let coinsNavController = UINavigationController(rootViewController: coinsViewCOntroller)
        coinsNavController.tabBarItem = UITabBarItem(title: "COINS", image: nil, tag: 0)
        coinsNavController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        
        let chartViewController = ChartViewController()
        let chartNavController = UINavigationController(rootViewController: chartViewController)
        chartNavController.tabBarItem = UITabBarItem(title: "BIỂU ĐỒ", image: nil, tag: 1)
        chartNavController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium)], for: .normal)
        
        tabBar.viewControllers = [chartNavController, coinsNavController]
        tabBar.delegate = self
        tabBar.tabBar.tintColor = .customGreen
        
        view.addSubview(tabBar.view)
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.view.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 10),
            tabBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tabBar.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            tabBar.view.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        searchButton = createButton(title: "Tìm kiếm")
        
        searchButton.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
        
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 10),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        underlineView = UIView()
        underlineView?.backgroundColor = .customGreen
        tabBar.view.addSubview(underlineView!)
    }
    
    // Thanh tìm kiếm
    func setUpSearchBar(){
        searchBar.isHidden = true
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func toggleSearchBar() {
        searchBar.isHidden.toggle()
        tabBar.view.isHidden.toggle()
        if searchBar.isHidden {
            searchButton.setTitle("Tìm kiếm", for: .normal)
        } else {
            searchButton.setTitle("Hủy", for: .normal)
        }
        
    }
    
    // Gạch dưới của 2 tab item
    func updateUnderlinePosition() {
        guard let underlineView = underlineView else { return }
        
        let itemWidth = tabBar.tabBar.bounds.width / CGFloat(tabBar.tabBar.items?.count ?? 1)
        let xPosition = CGFloat(tabBar.selectedIndex) * itemWidth
        
        UIView.animate(withDuration: 0.1) {
            underlineView.frame = CGRect(x: xPosition, y: self.tabBar.view.bounds.height - 3, width: itemWidth, height: 3)
        }
    }
    
    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.tintColor = .customGreen
        return button
    }
    
    // Các vạch seperator
    func addFirstSeparator() {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        if let lastSubview = view.subviews.dropLast().last {
            separator.topAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 10).isActive = true
        } else {
            separator.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        }
    }
    func addSecondSeparator() {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        if let lastSubview = view.subviews.dropLast().last {
            separator.topAnchor.constraint(equalTo: lastSubview.bottomAnchor, constant: 0).isActive = true
        } else {
            separator.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        }
    }
}

extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateUnderlinePosition()
        if tabBarController.selectedIndex == 0 {
            chartViewController.view.isHidden = false
            coinsViewController.view.isHidden = true
        } else if tabBarController.selectedIndex == 1 {
            chartViewController.view.isHidden = true
            coinsViewController.view.isHidden = false
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        coinsViewController.coinsViewModel.searchString = searchText
        coinsViewController.coinsViewModel.filterCoins()
    }
}
