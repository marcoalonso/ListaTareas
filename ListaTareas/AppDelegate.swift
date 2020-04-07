//
//  AppDelegate.swift
//  ListaTareas
//
//  Created by marco alonso on 29/03/20.
//  Copyright © 2020 marco alonso. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL!
              

        do {
            _ = try Realm()
            
        } catch {
            print("Error initialising realm, \(error.localizedDescription)")
        }
        
      
        return true
    }

}

