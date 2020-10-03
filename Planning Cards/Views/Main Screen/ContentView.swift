//
//  ContentView.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 11/11/19.
//  Copyright © 2019 Andre Yonadam. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    
    // MARK: - Constants
    
    let ReadyString = NSLocalizedString("Ready!", comment: "")
    
    // MARK: - Properties

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: DataManager.shared.DefaultDeckFetchRequest) var defaultDeck: FetchedResults<Deck>

    @State private var selectedCardValue = ""
    @State private var navigationOpacity = 1.0
    @State private var unrevealedCardOpacity = 0.0
    @State private var revealedSelectedCardOpacity = 0.0

    @ObservedObject var settingsManager: SettingsManager = SettingsManager()
    let columns = [
        GridItem(.adaptive(minimum: 100)),
        GridItem(.adaptive(minimum: 100)),
        GridItem(.adaptive(minimum: 100))
    ]

    var body: some View {
        ZStack {
            NavigationView {
                if defaultDeck.first?.cards?.count ?? 0 > 0 {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach((defaultDeck.first?.cards?.array as! [Card]), id: \.self) { (card: Card) in
                                CardView(cardColor: self.$settingsManager.cardColor,
                                         cardFontColor: self.$settingsManager.cardFontColor,
                                         value: card.value ?? "",
                                         largeText: false)
                                    .onTapGesture {
                                        self.selectedCardValue = card.value ?? ""

                                        self.unrevealedCardOpacity = 1.0
                                        self.revealedSelectedCardOpacity = 0.0
                                        self.navigationOpacity = 0.0
                                }
                            }
                            .frame(width: 100, height: 100, alignment: .center)
                        }
                        .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
                    }
                    .navigationBarTitle(defaultDeck.first?.name ?? "No default deck set!")
                    //FIXME: Button doesn't scale when text size changed while app is in background
                    .navigationBarItems(
                        trailing: NavigationLink(destination: SettingsView(settingsManager: settingsManager).environment(\.managedObjectContext, managedObjectContext)) {
                            Text("\u{2699}\u{0000FE0E}").font(
                                Font.custom("Ariel",
                                            size: UIFontMetrics(forTextStyle: .headline).scaledValue(for: 45)
                        ))}
                    )
                } else {
                    EmptyView()
                    .navigationBarTitle(defaultDeck.first?.name ?? "No default deck set!")
                    //FIXME: Button doesn't scale when text size changed while app is in background
                    .navigationBarItems(
                        trailing: NavigationLink(destination: SettingsView(settingsManager: settingsManager).environment(\.managedObjectContext, managedObjectContext)) {
                            Text("\u{2699}\u{0000FE0E}").font(
                                Font.custom("Ariel",
                                            size: UIFontMetrics(forTextStyle: .headline).scaledValue(for: 45)
                        ))}
                    )
                }
            }
            .opacity(navigationOpacity)
            .navigationViewStyle(StackNavigationViewStyle())
            
            CardView(cardColor: self.$settingsManager.cardColor,
                     cardFontColor: self.$settingsManager.cardFontColor,
                     value: ReadyString,
                     largeText: true)
                .opacity(unrevealedCardOpacity).animation(.spring())
                .onTapGesture {
                    self.unrevealedCardOpacity = 0.0
                    self.revealedSelectedCardOpacity = 1.0
                    self.navigationOpacity = 0.0
            }
            .edgesIgnoringSafeArea(.all)
            
            CardView(cardColor: self.$settingsManager.cardColor,
                     cardFontColor: self.$settingsManager.cardFontColor,
                     value: selectedCardValue,
                     largeText: true)
                .opacity(revealedSelectedCardOpacity)
                .onTapGesture {
                    self.unrevealedCardOpacity = 0.0
                    self.revealedSelectedCardOpacity = 0.0
                    self.navigationOpacity = 1.0
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Unable to read managed object context.")
        }
        return ContentView().environment(\.managedObjectContext, context)
    }
}
