//
//  ColorSelector.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 3/5/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import SwiftUI

struct ColorSelector: View {
    
    @Binding var selectedColor: String

    let cardColorNames: [String]
    let colors: [String: Color]
    let colorSelectionName: String

    var body: some View {
        List() {
            ForEach(cardColorNames, id: \.self) { key in
                Button(action: {
                    self.selectedColor = key
                }) {
                    HStack {
                        if key == self.selectedColor {
                            Image(systemName: "checkmark").foregroundColor(Color.blue)
                        } else {
                            Image(systemName: "checkmark").opacity(0)
                        }
                        Text(LocalizedColorNames[key] ?? "")
                        Spacer()
                        Circle()
                            .overlay(
                                Circle().stroke(Color.gray, lineWidth: 1)
                            )
                            .foregroundColor(self.colors[key])
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle(Text(colorSelectionName), displayMode: .inline)
    }
}

struct ColorSelector_Previews: PreviewProvider {
    static var previews: some View {
        if let firstColor = Array(CardColors.keys).first {
            return ColorSelector(selectedColor: .constant(firstColor), cardColorNames: Array(CardColors.keys), colors: CardColors, colorSelectionName: "Card Background Color")
        }
        else {
            return ColorSelector(selectedColor: .constant("Blue"), cardColorNames: Array(CardColors.keys), colors: CardColors, colorSelectionName: "Card Background Color")
        }
    }
}
