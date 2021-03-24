//
//  AppDelegate.swift
//  CRX Demo App
//
//  Created by Daniel Fredrich on 08.02.21.
//

import UIKit
import CPXResearch

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let style = CPXConfiguration.CPXStyleConfiguration(position: .side(position: .right, size: .normal),
                                                           text: "Verdiene bis zu 3 Coins in<br> 4 Minuten mit Umfragen",
                                                           textColor: "#ffffff",
                                                           backgroundColor: "#00af20",
                                                           roundedCorners: true)

        let config = CPXConfiguration(appId: "",
                                      extUserId: "",
                                      secureHash: "",
                                      style: style)
        CPXResearch.setup(with: config)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

