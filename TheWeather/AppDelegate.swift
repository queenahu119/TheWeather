//
//  AppDelegate.swift
//  TheWeather
//
//  Created by QueenaHuang on 17/5/18.
//  Copyright © 2018 queenahu. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        openRealm()

//        let realm = try! Realm()
//        try? realm.write({
//            realm.deleteAll()
//        })

        print(Realm.Configuration.defaultConfiguration.fileURL!)

        return true
    }

    func openRealm() {

        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL!
        let initialURL = Bundle.main.url(forResource: "initial", withExtension: "realm")

        if !FileManager.default.fileExists(atPath: defaultRealmPath.absoluteString) {
            do {
                try FileManager.default.copyItem(at: initialURL!, to: defaultRealmPath)
            } catch {

            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
