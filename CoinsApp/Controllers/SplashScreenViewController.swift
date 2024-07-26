//
//  SplashScreenViewController.swift
//  CoinsApp
//
//  Created by Nguyễn Duy Linh on 25/7/24.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let logoImageView = UIImageView(image: UIImage(named: "splash3"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.navigateToMainScreen()
        }
    }
    
    func navigateToMainScreen() {
        let homeVC = HomeViewController()
        let settingsVC = SettingViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNav, settingsNav]
        
        tabBarController.tabBar.backgroundColor = .lightGray
        tabBarController.tabBar.tintColor = .customGreen
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = tabBarController
    }
}
