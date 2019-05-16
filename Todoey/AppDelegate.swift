//
//  AppDelegate.swift
//  Todoey
//
//  Created by Aleksandar Tesanovic on 5/9/19.
//  Copyright © 2019 Aleksandar Tesanovic. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        do {
            _ = try Realm()
        } catch {
            print("Can not init Realm")
        }

        return true
    }

   
}

