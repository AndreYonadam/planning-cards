//
//  File.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 11/15/19.
//  Copyright © 2019 Andre Yonadam. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    
    // MARK: - Constants

    static let shared = DataManager()
    let appDelegate = UIApplication.shared.delegate
    
    enum Entity: String {
        case deck = "Deck"
        case card = "Card"
    }

    enum DeckKeys: String {
        case name = "name"
    }
    
    enum CardKeys: String {
        case value = "value"
        case deck = "deck"
    }
    
    // MARK: - Properties
    
    var AllDecksFetchRequest: NSFetchRequest<Deck> {
        let fetchRequest = NSFetchRequest<Deck>(entityName: Entity.deck.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: DeckKeys.name.rawValue, ascending: true)]
        return fetchRequest
    }
    
    var DefaultDeckFetchRequest: NSFetchRequest<Deck> {
        let fetchRequest = NSFetchRequest<Deck>(entityName: Entity.deck.rawValue)
        fetchRequest.predicate = NSPredicate(format: "isDefault = %@", argumentArray: [true])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: DeckKeys.name.rawValue, ascending: true)]
        return fetchRequest
    }
    
    var AllCardsFetchRequest: NSFetchRequest<Card> {
        let fetchRequest = NSFetchRequest<Card>(entityName: Entity.card.rawValue)
        fetchRequest.sortDescriptors = []
        return fetchRequest
    }

    // MARK: - Methods
    
    public func createDeck(name: String) -> NSManagedObject? {
        let deckEntity = createEntity(entity: .deck)
        deckEntity?.setValue(name, forKey: DeckKeys.name.rawValue)
        saveChanges()
        return deckEntity
    }

    public func createCard(value: String, deck: NSManagedObject) -> NSManagedObject? {
        let cardEntity = createEntity(entity: .card)
        cardEntity?.setValue(deck, forKey: CardKeys.deck.rawValue)
        cardEntity?.setValue(value, forKey: CardKeys.value.rawValue)
        saveChanges()
        return cardEntity
    }
    
    public func createDeckWithCards(deckName: String, cardNames: [String]) -> NSManagedObject? {
        guard let deck = DataManager.shared.createDeck(name: deckName) else {
            return nil
        }
        
        for cardName in cardNames {
            let _ = DataManager.shared.createCard(value: cardName, deck: deck)
        }
        
        return deck
    }
    
    public func replaceDeckAndCardValues(for deckId: NSManagedObjectID, deckName: String, newCards: [String]) {
        guard let deck = getObjectById(deckId) as? Deck,
              let oldCards = deck.cards?.array
        else {
            return
        }
        
        deck.name = deckName
        
        for case let card as Card in oldCards {
            deleteObject(card)
        }
        
        for cardValue in newCards {
            let cardEntity = createEntity(entity: .card)
            cardEntity?.setValue(deck, forKey: CardKeys.deck.rawValue)
            cardEntity?.setValue(cardValue, forKey: CardKeys.value.rawValue)
        }
        
        saveChanges()
    }
    
    public func deleteDeckAndCards(deckId: NSManagedObjectID) {
        guard let deck = getObjectById(deckId) as? Deck,
              let cards = deck.cards?.array
        else {
            return
        }
        
        for case let card as Card in cards {
            deleteObject(card)
        }

        deleteObject(deck)
    }

    public func fetchRequestCardsFor(deckName: String) -> NSFetchRequest<Card> {
        let fetchRequest = NSFetchRequest<Card>(entityName: Entity.card.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
        let findDescriptor = NSPredicate(format: "deck.name == %@", deckName)
        fetchRequest.predicate = findDescriptor
        return fetchRequest
    }
    
    public func setDefaultDeck(deck: NSManagedObject) {
        do {
            let managedContext = getManagedContext()
            guard let fetchResults = try managedContext?.fetch(AllDecksFetchRequest) else {
                return
            }
            
            for result in fetchResults {
                result.isDefault = false
                saveChanges()
            }
            
            if let deck = deck as? Deck {
                deck.isDefault = true
                saveChanges()
            }
            
        } catch let error as NSError {
            print("Could not remove default decks. \(error), \(error.userInfo)")
        }
    }
    
    public func getDefaultDeck() -> Deck? {
        let managedContext = getManagedContext()
        guard let fetchResults = try? managedContext?.fetch(DefaultDeckFetchRequest) else { return nil }
        
        return fetchResults.first
    }
    
    public func getCardsForDefaultDeck() -> [String] {
        guard let defaultDeck = getDefaultDeck(),
              let cards = defaultDeck.cards
        else {
            return []
        }
        
        var cardValues = [String]()
        for case let card as Card in cards {
            cardValues.append(card.value ?? "")
        }

        return cardValues
    }
    
    public func deleteAllData() {
        let managedContext = getManagedContext()
        guard let persistantStoreCoordinator = managedContext?.persistentStoreCoordinator,
            let persistantStoreCoordinatorURL = persistantStoreCoordinator.persistentStores.first?.url,
            let persistantStoreCoordinatorType = persistantStoreCoordinator.persistentStores.first?.type else {
                return
        }
        do {
          try persistantStoreCoordinator.destroyPersistentStore(at: persistantStoreCoordinatorURL, ofType: persistantStoreCoordinatorType)
            try persistantStoreCoordinator.destroyPersistentStore(at: persistantStoreCoordinatorURL, ofType: persistantStoreCoordinatorType)
            try persistantStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistantStoreCoordinatorURL)
        } catch {
        
        }
    }
    
    private func getObjectById(_ id: NSManagedObjectID) -> NSManagedObject? {
        guard let managedContext = getManagedContext() else {
            return nil
        }

        return managedContext.object(with: id)
    }
    
    private func deleteObject(_ object: NSManagedObject) {
        guard let managedContext = getManagedContext() else {
            return
        }

        managedContext.delete(object)
        
        saveChanges()
    }
    
    private func getManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate = appDelegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    private func createEntity(entity: Entity) -> NSManagedObject? {
        guard let managedContext = getManagedContext() else {
            return nil
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: entity.rawValue, in: managedContext) else {
            return nil
        }

        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)

        return managedObject
    }
    
    private func saveChanges() {
        guard let managedContext = getManagedContext() else {
            return
        }

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        WatchSessionController.shared.sendData()
    }
}

// MARK: - UserDefaults

extension UserDefaults {

    public struct Keys {
        static let cardColor = "CardColor"
        static let cardFontColor = "CardFontColor"
    }

    static var cardColor: String {
        get {
            if let color = UserDefaults.standard.object(forKey: Keys.cardColor) as? String {
                return color
            } else {
                return "blue"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cardColor)
            WatchSessionController.shared.sendData()
        }
    }

    static var cardFontColor: String {
        get {
            if let color = UserDefaults.standard.object(forKey: Keys.cardFontColor) as? String {
                return color
            } else {
                return "blue"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cardFontColor)
            WatchSessionController.shared.sendData()
        }
    }
}

// MARK: - SettingsManager

class SettingsManager: ObservableObject {
    
    @Published var cardColor: String = UserDefaults.cardColor {
        willSet {
            UserDefaults.cardColor = newValue
        }
    }

    @Published var cardFontColor: String = UserDefaults.cardFontColor {
        willSet {
            UserDefaults.cardFontColor = newValue
        }
    }
}
