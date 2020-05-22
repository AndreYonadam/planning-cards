//
//  DeckModifier.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 2/19/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import SwiftUI
import CoreData

struct DeckEditor: View {
    
    // MARK: - Properties

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject private var keyboard = KeyboardResponder()

    @State public var deckName: String
    @State public var cards: [String]
    
    public let deckIdentifer: NSManagedObjectID
    public let isDefault: Bool
    
    var body: some View {
        List {
            DeckConfigurationSection(deckName: $deckName)
            CardConfigurationSection(cards: $cards)
            Section(header: EmptyView()) {
                Button(action: {
                    DataManager.shared.deleteDeckAndCards(deckId: self.deckIdentifer)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Delete deck")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Edit Deck"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                DataManager.shared.replaceDeckAndCardValues(for: self.deckIdentifer, deckName: self.deckName, newCards: self.cards)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(Font.title.weight(.medium))
                        .aspectRatio(contentMode: .fit)
                    Text("Back")
                }
            })
        )
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
    }
    
    // MARK: - Init

    init(deck: Deck) {
        self.deckIdentifer = deck.objectID
        self.isDefault = deck.isDefault
        
        self._deckName = State(initialValue: deck.name ?? "")
        let cards = deck.cards?.array as! [Card]
        let cardValues = cards.map { $0.value ?? "" }
        self._cards = State(initialValue: cardValues)
    }
}

struct DeckModifier_Previews: PreviewProvider {
    static var previews: some View {
        DeckEditor(deck: Deck())
    }
}
