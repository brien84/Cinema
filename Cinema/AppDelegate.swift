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

        // Makes `navigationBar` transparent.
        let image = UIColor.transparentBlackC.image(size: controller.navigationBar.frame.size)
        controller.navigationBar.setBackgroundImage(image, for: .default)
        controller.navigationBar.shadowImage = UIImage()

        // Setting `backBarButtonItem` to a new `UIBarButtonItem` keeps empty back button title
        // across all View Controllers in the app.
        controller.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem()

        guard let font = UIFont(name: "Avenir-Medium", size: .dynamicFontSize(15)) else { fatalError() }
        controller.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.lightC, .font: font]

        controller.navigationBar.tintColor = .lightC

        return controller
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        // Opens `OptionsViewController` if the app is started for the first time.
        if !UserDefaults.standard.isCitySet() {
            navigationController.pushViewController(OptionsViewController(), animated: false)
        }

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
