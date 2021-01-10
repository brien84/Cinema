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

        let navController = window?.rootViewController as? UINavigationController
        navController?.navigationBar.shadowImage = UIImage()
        navController?.navigationBar.setBackgroundImage(color: .secondaryBackground)

        // Opens `SettingsViewController` if the app is started for the first time or if UI tests commence.
        if !UserDefaults.standard.isCitySet() || CommandLine.arguments.contains("ui-testing") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let optionsVC = storyboard.instantiateViewController(withIdentifier: "OptionsVC")
            navController?.pushViewController(optionsVC, animated: false)
        }

        return true
    }
}
