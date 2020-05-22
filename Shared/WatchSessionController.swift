//
//  WatchSessionController.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 3/26/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import SwiftUI
import Foundation
import WatchConnectivity

extension Notification.Name {
    static let dataUpdate = Notification.Name("DataUpdate")
}

struct PayloadKey {
    static let deckName = "DeckName"
    static let cards = "Cards"
    static let cardColor = "CardColor"
    static let cardFontColor = "CardFontColor"
}

struct PayloadData: Codable {
    let deckName: String
    let cards: [String]
    let cardColor: String
    let cardFontColor: String
}

class WatchSessionController: NSObject {
    
    // MARK: - Properties
    
    var watchSession: WCSession?
    static let shared = WatchSessionController()
    
    
    // MARK: - Methods
    
    public func activateWatchSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            watchSession = WCSession.default
        }
    }
    
    #if os(iOS)
    public func sendData() {
        DispatchQueue.main.async {
            guard let watchSession = self.watchSession else { return }
            
            guard let defaultDeckName = DataManager.shared.getDefaultDeck()
                else { return }
            let cardValues = DataManager.shared.getCardsForDefaultDeck()
            let cardColor = UserDefaults.cardColor
            let cardFontColor = UserDefaults.cardFontColor
            let payloadData = PayloadData(deckName: defaultDeckName.name ?? "",
                                          cards: cardValues,
                                          cardColor: cardColor,
                                          cardFontColor: cardFontColor)

            if watchSession.isReachable {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(payloadData) {
                    watchSession.sendMessageData(encoded, replyHandler: nil, errorHandler: nil)
                }
            }
        }
    }
    #endif
}

// MARK: - WCSessionDelegate

extension WatchSessionController: WCSessionDelegate {
    #if os(iOS)
    func sessionWatchStateDidChange(_ session: WCSession) {
        sendData()
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        sendData()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        sendData()
    }
    #endif

    #if os(watchOS)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Ping the phone to have it send the data
        session.sendMessage([:], replyHandler: nil, errorHandler: nil)
    }

    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        NotificationCenter.default.post(name: .dataUpdate, object: messageData)
    }
    #endif
}
