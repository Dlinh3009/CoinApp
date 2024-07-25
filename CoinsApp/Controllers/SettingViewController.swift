//
//  SettingViewController.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 19/7/24.
//

import UIKit

class SettingViewController: UIViewController {
    
    let darkModeSwitch = UISwitch()
    let darkModeLabel = UILabel()
    
    let currencySegmentedControl = UISegmentedControl(items: ["USD", "EUR", "VND"])
    let currencyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        
        let currentIndex = UserDefaults.standard.integer(forKey: "currencyIndex")
        currencySegmentedControl.selectedSegmentIndex = currentIndex
    }
    
    func setupUI() {
        
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchChanged), for: .valueChanged)
        
        darkModeLabel.text = "Chế độ tối"
        darkModeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        darkModeLabel.textColor = .customGreen
        darkModeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let darkModeStackView = UIStackView(arrangedSubviews: [darkModeLabel, darkModeSwitch])
        darkModeStackView.axis = .horizontal
        darkModeStackView.spacing = 20
        darkModeStackView.translatesAutoresizingMaskIntoConstraints = false
        darkModeStackView.distribution = .fillEqually
        
        currencySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        currencySegmentedControl.addTarget(self, action: #selector(currencySegmentChanged), for: .valueChanged)
        currencySegmentedControl.backgroundColor = .customGreen
        
        currencyLabel.text = "Đơn vị tiền tệ"
        currencyLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        currencyLabel.textColor = .customGreen
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let currencyStackView = UIStackView(arrangedSubviews: [currencyLabel, currencySegmentedControl])
        currencyStackView.axis = .horizontal
        currencyStackView.spacing = 20
        currencyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [darkModeStackView, currencyStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func darkModeSwitchChanged() {
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        
        if darkModeSwitch.isOn {
            windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
            UserDefaults.standard.set(true, forKey: "isDarkMode")
        } else {
            windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            UserDefaults.standard.set(false, forKey: "isDarkMode")
        }
    }
    
    @objc func currencySegmentChanged() {
        let selectedIndex = currencySegmentedControl.selectedSegmentIndex
        UserDefaults.standard.set(selectedIndex, forKey: "currencyIndex")
        CurrencyManager.shared.updateCurrency()
        NotificationCenter.default.post(name: .currencyDidChange, object: nil)
    }
}
