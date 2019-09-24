//
//  AppDelegate.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 24/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        setupRealm()
        
        return true
    }
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SplashScreenViewController()
        window?.makeKeyAndVisible()
    }
    
    private func setupRealm() {
        let realmLocation = Realm.Configuration.defaultConfiguration.fileURL
        print("Realm data file location: ", realmLocation ?? "")
    }
}
