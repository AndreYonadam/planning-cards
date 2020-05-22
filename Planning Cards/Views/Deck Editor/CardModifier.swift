//
//  CardModifier.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 2/1/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import SwiftUI
import CoreData

struct CardModifier: View {
    
    // MARK: - Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @Binding public var cards: [String]

    var body: some View {
        List {
            ForEach(cards, id: \.self) { (value) in
                HStack {
                    Text(value)
                }
            }
            .onMove(perform: move(from:to:))
            .onDelete(perform: delete(at:))
        }
        .listStyle(PlainListStyle())
        .environment(\.editMode, .constant(.active))
        .navigationBarTitle(Text("Sort Cards"))
    }
    
    // MARK: - Methods
    
    func delete(at offsets: IndexSet) {
        if let firstOffset = offsets.first {
            cards.remove(at: firstOffset)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        cards.move(fromOffsets: source, toOffset: destination)
    }
}

struct CardModifier_Previews: PreviewProvider {
    static var previews: some View {
        return CardModifier(cards: .constant(["1", "2", "3"]))
    }
}
