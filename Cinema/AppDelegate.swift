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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // TODO: move to closure porperties?
        let navController = UINavigationController(rootViewController: DateContainerVC())
        navController.navigationBar.tintColor = Constants.Colors.light
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : Constants.Colors.dark]
        
        let backButton = UIBarButtonItem()
        backButton.tintColor = Constants.Colors.blue
        backButton.title = ""
        navController.navigationBar.topItem?.backBarButtonItem = backButton

        /// Opens city menu on first start.
        if isFirstStart() {
            navController.pushViewController(OptionsVC(), animated: false)
        }

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func isFirstStart() -> Bool {
        return UserDefaults.standard.readCity() == nil
    }
}

