//
//  CardView.swift
//  Planning Cards
//
//  Created by Andre Yonadam on 11/24/19.
//  Copyright © 2019 Andre Yonadam. All rights reserved.
//

import SwiftUI
import Combine

struct CardView: View {
    
    // MARK: - Constants
    
    static let TextSafeAreaPadding: CGFloat = 10.0
    
    // MARK: - Properties
    
    @Binding var cardColor: String
    @Binding var cardFontColor: String
    
    let OptimalFontSizeForScreenSize: CGFloat
    var value: String
    var largeText: Bool
    
    var body: some View {
        VStack {
            if largeText == true {
                Text(value)
                    .font(.system(size: OptimalFontSizeForScreenSize))
                    .foregroundColor(CardFontColors[cardFontColor])
                    .minimumScaleFactor(.leastNormalMagnitude)
                    .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .background(CardColors[cardColor])
            } else {
                VStack {
                    Text(value)
                        .font(.system(size: UIFontMetrics(forTextStyle: .body).scaledValue(for: 35)))
                        .foregroundColor(CardFontColors[cardFontColor])
                        .fontWeight(.bold)
                        .minimumScaleFactor(.leastNormalMagnitude)
                        .lineLimit(1)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .background(CardColors[cardColor])
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white, lineWidth: 5)
                        .opacity(0.4)
                )
            }
        }
    }
    
    // MARK: - Init
    
    init(cardColor: Binding<String>, cardFontColor: Binding<String>, value: String, largeText: Bool) {
        self._cardColor = cardColor
        self._cardFontColor = cardFontColor
        self.value = value
        self.largeText = largeText
        if largeText {
            let optimalFontSizeForScreenWidth = Self.findFontSizeToFillWidth(text: value)
            OptimalFontSizeForScreenSize = Self.findFontSizeToFillHeight(text: value, maximumFontSize: optimalFontSizeForScreenWidth)
        }
        else {
            OptimalFontSizeForScreenSize = 35
        }
    }
    
    // MARK: - Functions
    
    static func findFontSizeToFillWidth(text: String) -> CGFloat {
        guard text != "" else { return 50.0 }
        
        let IncrementFontSizeBy: CGFloat = 1.0
        var fontSize: CGFloat = 0.0
        var widthForCurrentFontSize: CGFloat = 0.0
        #if os(watchOS)
        let screenWidth = WKInterfaceDevice.current().screenBounds.size.width - TextSafeAreaPadding
        #elseif os(iOS)
        let screenWidth = UIScreen.main.bounds.width - TextSafeAreaPadding
        #endif
        while widthForCurrentFontSize < screenWidth {
            fontSize = fontSize + IncrementFontSizeBy
            widthForCurrentFontSize = text.size(withAttributes:[.font: UIFont.systemFont(ofSize: fontSize)]).width
        }
        return fontSize
    }
    
    static func findFontSizeToFillHeight(text: String, maximumFontSize: CGFloat) -> CGFloat {
        guard text != "" else { return 50.0 }
        
        let DecrementFontSizeBy: CGFloat = 1.0
        var fontSize: CGFloat = maximumFontSize
        var heightForCurrentFontSize: CGFloat = text.size(withAttributes:[.font: UIFont.systemFont(ofSize: fontSize)]).height
        #if os(watchOS)
        let screenHeight = WKInterfaceDevice.current().screenBounds.size.height - TextSafeAreaPadding
        #elseif os(iOS)
        let screenHeight = UIScreen.main.bounds.height - TextSafeAreaPadding
        #endif
        while heightForCurrentFontSize > screenHeight {
            fontSize = fontSize - DecrementFontSizeBy
            heightForCurrentFontSize = text.size(withAttributes:[.font: UIFont.systemFont(ofSize: fontSize)]).height
        }
        return fontSize
    }
}

struct CardView_Previews: PreviewProvider {
    static var value: String = "Hello World!"

    static var previews: some View {
        CardView(cardColor: .constant("blue"), cardFontColor: .constant("blue"), value: value, largeText: false)
    }
}
