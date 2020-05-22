//
//  HostingController.swift
//  Planning Cards WatchKit Extension
//
//  Created by Andre Yonadam on 11/11/19.
//  Copyright © 2019 Andre Yonadam. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
        
    override var body: ContentView {
        var payloadData: PayloadData?
        
        if let mostRecentData = UserDefaults.mostRecentData {
            do {
                try payloadData = PropertyListDecoder().decode(PayloadData.self, from: mostRecentData)
            } catch {
            }
        }
        
        return ContentView(payloadData: .constant(payloadData))
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdate(_:)), name: .dataUpdate, object: nil)
    }
    
    @objc func dataUpdate(_ notification: Notification) {
        let decoder = JSONDecoder()
        guard let messageData = notification.object as? Data,
              let payloadData = try? decoder.decode(PayloadData.self, from: messageData)
        else {
            return
        }
        
        do {
            try UserDefaults.mostRecentData = PropertyListEncoder().encode(payloadData)
        } catch  {
            
        }
        
        setNeedsBodyUpdate()
    }
}

extension UserDefaults {

    public struct Keys {
        static let mostRecentData = "MostRecentData"
    }
    
    private static func archivePayloadData(payloadData: PayloadData) -> Data? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: payloadData, requiringSecureCoding: false)
        } catch {
            return nil
        }
    }

    static var mostRecentData: Data? {
        get {
            if let mostRecentData = UserDefaults.standard.object(forKey: Keys.mostRecentData) as? Data {
                return mostRecentData
            } else {
                let defaultPayloadData = PayloadData(deckName: FibonacciDeckName, cards: FibonacciCardValues, cardColor: DefualtCardColor, cardFontColor: DefualtCardFontColor)
                do {
                    return try PropertyListEncoder().encode(defaultPayloadData)
                } catch {
                    return nil
                }
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.mostRecentData)
        }
    }
}
