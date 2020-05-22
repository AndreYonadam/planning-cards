//
//  DeckCreator.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 2/9/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import SwiftUI
import CoreData

struct DeckCreator: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject private var keyboard = KeyboardResponder()

    @State private var deckName = ""
    @State private var cards = [String]()

    var body: some View {
        List {
            DeckConfigurationSection(deckName: $deckName)
            CardConfigurationSection(cards: $cards)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Create Deck"), displayMode: .inline)
        .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel").bold()
                }
            ), trailing:
                Button(action: {
                    _ = DataManager.shared.createDeckWithCards(deckName: self.deckName, cardNames: self.cards)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Create").bold()
                })
        )
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
    }
}

struct DeckCreator_Previews: PreviewProvider {
    static var previews: some View {
        return DeckCreator()
    }
}
