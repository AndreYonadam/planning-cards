//
//  Planning_Cards_UITests.swift
//  Planning Cards UITests
//
//  Created by Andre Yonadam on 4/5/20.
//  Copyright © 2020 Andre Yonadam. All rights reserved.
//

import XCTest

class Planning_Cards_UITests: XCTestCase {
    
    // MARK: - Methods

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testScreenshots() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchEnvironment = ["UITests": "1"]
        app.launch()

        // MARK: - Screenshot 1 (Main Screen Fibonacci Deck)
        snapshot("0MainScreenFibonacciDeck")

        let fibonacciNavigationBar = app.navigationBars["Fibonacci"]
        let button = fibonacciNavigationBar.buttons["⚙︎"]
        let tablesQuery = app.tables
        let elementsQuery = app.scrollViews.otherElements

        // Bring up the "Ready" screen
        elementsQuery.staticTexts["2"].tap()

        // MARK: - Screenshot 2 (Ready Screen)
        snapshot("1ReadyScreen")

        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
        let element3 = element2.children(matching: .other).element.children(matching: .other).element
        let element = element3.children(matching: .other).element

        // Bring up the selected card value
        element.tap()

        // MARK: - Screenshot 3 (Card Value 2)
        snapshot("2CardValue2")

        // Dismiss the selected card
        element.tap()

        // Bring up the settings menu
        button.tap()

        // MARK: - Screenshot  4 (Settings Menu)
        snapshot("3SettingsMenu")

        // Go to the background colors screen
        tablesQuery.children(matching: .cell).element(boundBy: 3).tap()

        // MARK: - Screenshot 5 (Background Colors)
        snapshot("4BackgroundColors")

        // Go back to the settings screen
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Go to the default decks screen
        tablesQuery.children(matching: .cell).element(boundBy: 0).tap()

        // Go back to the settings screen
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Go to the manage decks screen
        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()

        // Manage the "Fibonacci" deck
        tablesQuery.buttons["Fibonacci"].tap()

        // Go back to the manage decks screen
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Go to the create new deck screen
        app.navigationBars.buttons.element(boundBy: 1).tap()
        let customDeckNameText = localized("Deck Name")
        let myDeckNameTextField = app.textFields.element(boundBy: 0)
        myDeckNameTextField.tap()
        for c in customDeckNameText {
            myDeckNameTextField.typeText(String(c))
        }
        myDeckNameTextField.typeText("\n")
        let addCardButton = tablesQuery.buttons[localized("add card")]
        addCardButton.tap()
        let firstField = tablesQuery.cells.element(boundBy: 1).textFields.element(boundBy: 0)
        firstField.tap()
        firstField.typeText("1")
        addCardButton.tap()
        let secondField = tablesQuery.cells.element(boundBy: 2).textFields.element(boundBy: 0)
        secondField.tap()
        secondField.typeText("2")
        addCardButton.tap()
        let thirdField = tablesQuery.cells.element(boundBy: 3).textFields.element(boundBy: 0)
        thirdField.tap()
        thirdField.typeText("3")
        addCardButton.tap()
        let fourthField = tablesQuery.cells.element(boundBy: 4).textFields.element(boundBy: 0)
        fourthField.tap()
        let customCardNameText = localized("Hello")
        for c in customCardNameText {
            fourthField.typeText(String(c))
        }
        fourthField.typeText("\n")
        tablesQuery.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // MARK: - Screenshot 6 (Edit Deck)
        snapshot("5EditDeck")

        // Create the deck and go back to the manage decks screen
        app.navigationBars.buttons.element(boundBy: 1).tap()

        // MARK: - Screenshot 7 (Manage Decks)
        snapshot("6ManageDecks")

        // Go back to the settings screen
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Go to the default decks screen
        tablesQuery.children(matching: .cell).element(boundBy: 0).tap()
        tablesQuery.buttons[customDeckNameText].tap()

        // MARK: - Screenshot 8 (Default Decks)
        snapshot("7DefaultDecks")

        // Go back to the settings screen
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Go back to the main screen
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // MARK: - Screenshot 9 (Main Screen Custom Deck)
        snapshot("8MainScreenCustomDeck")

        // Bring up the "Ready" screen
        elementsQuery.staticTexts[customCardNameText].tap()

        // Bring up the selected card value
        elementsQuery.staticTexts[customCardNameText].tap()

        // MARK: - Screenshot 10 (Card Value Custom)
        snapshot("9CardValueCustom")
    }
    
    func localized(_ key: String) -> String {
        let uiTestBundle = Bundle(for: SharedLocalizationClass.self)
        return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
    }
}
