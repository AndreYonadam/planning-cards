//
//  DeckConfigurationSection.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 2/21/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import SwiftUI

struct DeckConfigurationSection: View {
    
    // MARK: - Properties

    @Binding public var deckName: String

    var body: some View {
        Section(header: EmptyView()) {
            HStack {
                Text("Deck Name")

                Spacer(minLength: 20)

                TextField("My Deck Name", text: $deckName)
            }
        }
    }
}

struct DeckConfigurationSection_Previews: PreviewProvider {
    static var previews: some View {
        DeckConfigurationSection(deckName: .constant(""))
    }
}
