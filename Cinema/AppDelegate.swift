//
//  AppDelegate.swift
//  Cinema
//
//  Created by Marius on 21/09/2019.
//  Copyright © 2019 Marius. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private lazy var navigationController: UINavigationController = {
        let controller = UINavigationController(rootViewController: DailyViewController())
        controller.navigationBar.tintColor = Constants.Colors.light
        controller.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Constants.Colors.dark]
        controller.navigationBar.topItem?.backBarButtonItem = backButton
        
        return controller
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.tintColor = Constants.Colors.blue
        button.title = ""
        
        return button
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        /// Opens options menu on first start.
        if !UserDefaults.standard.isCitySet() {
            navigationController.pushViewController(OptionsViewController(), animated: false)
        }

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

