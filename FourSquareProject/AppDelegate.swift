//
//  AppDelegate.swift
//  FourSquareProject
//
//  Created by Leo on 13.10.2019.
//  Copyright © 2019 Leo. All rights reserved.
//

import Swinject
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let injector: InjectorProtocol = Injector()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let router = injector.resolve(
            RouterProtocol.self,
            arguments: UINavigationController(),
            Screen.places
            )!
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = router.rootViewController
        window.makeKeyAndVisible()
        
        return true
    }
}

