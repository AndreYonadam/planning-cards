//
//  AppDelegate.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 11/11/19.
//  Copyright © 2019 Andre Yonadam. All rights reserved.
//

import UIKit
import CoreData

let AppAlreadyLaunchedKey = "isAppAlreadyLaunchedOnce"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let env = ProcessInfo.processInfo.environment
        if let uiTests = env["UITests"],
           uiTests == "1" {
            // If we are running UITests wipe the application data
            
            // Clear UserDefaults
            if let domain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
            }

            // Clear Core Data
            DataManager.shared.deleteAllData()
            
            // Disable animations
            UIView.setAnimationsEnabled(false)
        }
        
        // Override point for customization after application launch.
        WatchSessionController.shared.activateWatchSession()

        if !isAppAlreadyLaunchedOnce {
            if let fibonacciDeck = DataManager.shared.createDeckWithCards(deckName: FibonacciDeckName, cardNames: FibonacciCardValues) {
                DataManager.shared.setDefaultDeck(deck: fibonacciDeck)
            }
            
            _ = DataManager.shared.createDeckWithCards(deckName: FibonnaciHalfPointDeckName, cardNames: FibonacciHalfPointCardValues)
            
            _ = DataManager.shared.createDeckWithCards(deckName: PlayingCardDeckName, cardNames: PlayingCardValues)
            
            if CardColors.keys.contains(DefualtCardColor) {
                UserDefaults.cardColor = DefualtCardColor
            } else if let firstCardColor = CardColors.keys.first {
                UserDefaults.cardColor = firstCardColor
            }
            
            if CardFontColors.keys.contains(DefualtCardFontColor) {
                UserDefaults.cardFontColor = DefualtCardFontColor
            } else if let firstCardFontColor = CardFontColors.keys.first {
                UserDefaults.cardFontColor = firstCardFontColor
            }
        }
        
        return true
    }
    
    private var isAppAlreadyLaunchedOnce: Bool {
        let defaults = UserDefaults.standard

        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: AppAlreadyLaunchedKey) {
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        } else {
            defaults.set(true, forKey: AppAlreadyLaunchedKey)
            print("App launched first time")
            return false
        }
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
    
    // MARK: Core Data
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show the error here
            }
        }
    }

}

