//
//  ContentView.swift
//  Planning Cards WatchKit Extension
//
//  Created by Andre Yonadam on 11/11/19.
//  Copyright © 2019 Andre Yonadam. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Constants
    
    let ReadyString = NSLocalizedString("Ready!", comment: "")
    
    // MARK: - Properties
    
    @Binding var payloadData: PayloadData?
    
    @State private var selectedCardValue = ""
    @State private var navigationOpacity = 1.0
    @State private var unrevealedCardOpacity = 0.0
    @State private var revealedSelectedCardOpacity = 0.0

    var body: some View {
        ZStack {
            List(Array(payloadData?.cards ?? [String]()), id: \.self) { (cardValue: String) in
                Button(action: {
                    self.selectedCardValue = cardValue

                    self.unrevealedCardOpacity = 1.0
                    self.revealedSelectedCardOpacity = 0.0
                    self.navigationOpacity = 0.0
                    
                    self.disableScreenDimmingAndRotation()
                }, label: {
                    Text(cardValue)
                })
            }
            .opacity(navigationOpacity)
            
            CardView(cardColor: .constant(payloadData?.cardColor ?? "blue"),
                     cardFontColor: .constant(payloadData?.cardFontColor ?? "blue"),
                     value: ReadyString,
                     largeText: true)
                .opacity(unrevealedCardOpacity)
                .animation(.spring())
                .onTapGesture {
                    self.unrevealedCardOpacity = 0.0
                    self.revealedSelectedCardOpacity = 1.0
                    self.navigationOpacity = 0.0
            }
            .edgesIgnoringSafeArea(.all)
            
            CardView(cardColor: .constant(payloadData?.cardColor ?? "blue"),
                     cardFontColor: .constant(payloadData?.cardFontColor ?? "blue"),
                     value: selectedCardValue,
                     largeText: true)
                .opacity(revealedSelectedCardOpacity)
                .onTapGesture {
                    self.unrevealedCardOpacity = 0.0
                    self.revealedSelectedCardOpacity = 0.0
                    self.navigationOpacity = 1.0
                    
                    self.enableScreenDimmingAndRotation()
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private func enableScreenDimmingAndRotation() {
        WKExtension.shared().isAutorotating = true
    }
    
    private func disableScreenDimmingAndRotation() {
        WKExtension.shared().isAutorotating = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(payloadData: .constant(nil))
    }
}
