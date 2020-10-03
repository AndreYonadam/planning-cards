//
//  SettingsView.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 11/24/19.
//  Copyright © 2019 Andre Yonadam. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    // MARK: - Constants
    
    let SettingsText = NSLocalizedString("Settings", comment: "")
    let CardBackgroundColor = NSLocalizedString("Card Background Color", comment: "")
    let CardFontColor = NSLocalizedString("Card Font Color", comment: "")

    // MARK: - Properties

    @FetchRequest(fetchRequest: DataManager.shared.DefaultDeckFetchRequest) var defaultDeck: FetchedResults<Deck>

    @ObservedObject var settingsManager: SettingsManager

    var body: some View {
        List {
            Section(header: Text("Decks")) {
                NavigationLink(destination: DeckSelector()) {
                    HStack {
                        Text("Default Deck")
                        Spacer()
                        Text(defaultDeck.first?.name ?? "").foregroundColor(Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
                    }
                }
                NavigationLink(destination: DeckManager()) {
                    HStack {
                        Text("Manage Decks")
                    }
                }
            }
            Section(header: Text("Theme")) {
                NavigationLink(destination: ColorSelector(selectedColor: $settingsManager.cardColor, cardColorNames: Array(CardColors.keys), colors: CardColors, colorSelectionName: CardBackgroundColor)) {
                    HStack {
                        Text(CardBackgroundColor)
                        Spacer()
                        Text(LocalizedColorNames[settingsManager.cardColor] ?? "").foregroundColor(Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
                    }
                }
                NavigationLink(destination: ColorSelector(selectedColor: $settingsManager.cardFontColor, cardColorNames: Array(CardFontColors.keys), colors: CardFontColors, colorSelectionName: CardFontColor)) {
                    HStack {
                        Text(CardFontColor)
                        Spacer()
                        Text(LocalizedColorNames[settingsManager.cardFontColor] ?? "").foregroundColor(Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(SettingsText)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsManager: SettingsManager())
    }
}
