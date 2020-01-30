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
        
        ///
        let image = Colors.transparentBlack.image(size: controller.navigationBar.frame.size)
        controller.navigationBar.setBackgroundImage(image, for: .default)
        controller.navigationBar.shadowImage = UIImage()
        
        ///
        controller.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem()
        
        controller.navigationBar.tintColor = Colors.light
        controller.navigationBar.titleTextAttributes = [.foregroundColor : Colors.light]
    
        return controller
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
