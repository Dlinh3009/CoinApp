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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
    
    func setupUI() {
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchChanged), for: .valueChanged)
        view.addSubview(darkModeSwitch)
        
        NSLayoutConstraint.activate([
            darkModeSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            darkModeSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        darkModeLabel.text = "Dark Mode"
        darkModeLabel.textColor = .customGreen
        darkModeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(darkModeLabel)
        
        NSLayoutConstraint.activate([
            darkModeLabel.centerXAnchor.constraint(equalTo: darkModeSwitch.centerXAnchor),
            darkModeLabel.bottomAnchor.constraint(equalTo: darkModeSwitch.topAnchor, constant: -8)
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

}
