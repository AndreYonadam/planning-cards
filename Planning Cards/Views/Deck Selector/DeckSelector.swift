//
//  DeckManager.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 12/26/19.
//  Copyright © 2019 Andre Yonadam. All rights reserved.
//

import SwiftUI

struct DeckSelector: View {
    
    // MARK: - Properties

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: DataManager.shared.DefaultDeckFetchRequest) var defaultDeck: FetchedResults<Deck>
    @FetchRequest(fetchRequest: DataManager.shared.AllDecksFetchRequest) var decks: FetchedResults<Deck>

    var body: some View {
        List(self.decks, id: \.self) { (deck: Deck) in
            HStack {
                Button(action: {
                    DataManager.shared.setDefaultDeck(deck: deck)
                }) {
                    HStack {
                        if deck == self.defaultDeck.first {
                            Image(systemName: "checkmark").foregroundColor(Color.blue)
                        } else {
                            Image(systemName: "checkmark").opacity(0)
                        }
                        Text(deck.name ?? "")
                        Spacer()
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(Text(defaultDeck.first?.name ?? ""), displayMode: .inline)
    }
}

struct DeckSelector_Previews: PreviewProvider {
    static var previews: some View {
        DeckSelector()
    }
}
