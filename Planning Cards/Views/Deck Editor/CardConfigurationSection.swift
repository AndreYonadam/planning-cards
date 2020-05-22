//
//  CardConfigurationSection.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 2/21/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import SwiftUI

struct CardConfigurationSection: View {
    
    // MARK: - Constants
    
    let MaximumCardValueCharacters = 15
    let AddCardString = NSLocalizedString("add card", comment: "")
    
    // MARK: - Properties
    
    @Binding public var cards: [String]

    var body: some View {
        Section(header:
            HStack {
                Text("Cards")

                Spacer()

                NavigationLink(destination: CardModifier(cards: $cards)) {
                    Text("Edit")
                }
        }) {
            ForEach(cards.indices, id:\.self ){ index in
                TextField("card name", text: self.$cards[index])
            }

            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                self.cards.append("")
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.custom("San Francisco", size: UIFontMetrics(forTextStyle: .body).scaledValue(for: 23)))
                        .foregroundColor(.green)
                        .background(Circle().fill(Color.white))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    Text(AddCardString)
                    Spacer()
                }
            }
        }
    }
}

struct CardConfigurationSection_Previews: PreviewProvider {
    static var previews: some View {
        CardConfigurationSection(cards: .constant([""]))
    }
}
