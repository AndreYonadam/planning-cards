# Planning Cards - an iOS and a WatchKit App

## Tech Stack

Since I wanted to use Apple’s latest native tech stack, I ended up using SwiftUI for both the iOS app and the watch extension. This allowed me to share a few UI components between both platforms. I also used Grid, a SwiftUI library, to display the cards in a grid layout.

To store the custom deck data I used CoreData and set up relationships between cards and decks. CoreData allowed me to use FetchResultControllers in my SwiftUI views. Using FetchResultControllers is handy since SwiftUI handles the data to show and automatically updates it if the values change in CoreData. To store the user settings, I used UserDefaults.

To synchronize the custom deck data to the watch, I used WatchConnectivity and UserDefaults. WatchConnectivity was used to send the deck data from the iOS to the Apple Watch app. Since the Watch app only cares about the currently selected deck, it doesn’t need to know about any of the other decks that the user has created. That being said, we can use a simpler solution for storing the deck data on the watch app. This is why the watch app uses UserDefaults and doesn’t use CoreData.

## Localizations

Wanting to reach as wide of an audience as possible, Planning Cards is localized in English, Danish, German, Japanese, and Simplified Chinese.

## Deployment

If you check the automated UI Tests they include configuration for Fastlane’s Snapshot tool. This makes it easy to capture all the screenshots in all our 5 localizations. I also used Fastlane’s deliver tool to store my metadata. This could be helpful in the future when wanting to submit a future version of the app, so we won’t have to retype unchanged information in App Store Connect between all the different locales.

## License

This project is licensed under the terms of the MIT license.
