//
//  DeckManager.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 2/9/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import SwiftUI

struct DeckManager: View {
    
    // MARK: - Properties

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: DataManager.shared.AllDecksFetchRequest) var decks: FetchedResults<Deck>

    var body: some View {
        List(self.decks, id: \.self) { (deck: Deck) in
            NavigationLink(destination: DeckEditor(deck: deck)) {
                Text(deck.name ?? "")
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("Manage Decks", displayMode: .inline)
        .navigationBarItems(trailing:
            NavigationLink(destination: DeckCreator()) {
                Text("+").font(Font.custom("Ariel", size: UIFontMetrics(forTextStyle: .body).scaledValue(for: 35)))
            }
        )
    }
}

struct DeckManager_Previews: PreviewProvider {
    static var previews: some View {
        DeckManager()
    }
}
