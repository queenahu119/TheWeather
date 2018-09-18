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

        realmMigration()

//        let realm = try! Realm()
//        try? realm.write({
//            realm.deleteAll()
//        })

        print(Realm.Configuration.defaultConfiguration.fileURL!)

        return true
    }

    func realmMigration() {
        let config = Realm.Configuration(
            schemaVersion : 1,
            migrationBlock : { migration , oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    print("realmMigration: ")
                    migration.enumerateObjects(ofType: City.className(), { (oldObject, newObject) in
                        newObject!["coord"] = nil
                    })
                }
        }
        )
        Realm.Configuration.defaultConfiguration = config
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
