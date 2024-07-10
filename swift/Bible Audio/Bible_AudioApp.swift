//
//  Bible_AudioApp.swift
//  Bible Audio
//
//  Created by Andrew Boldi on 7/8/24.
//

import SwiftUI

@main
struct Bible_AudioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("selectedLanguage") var selectedLanguage: String?

    var body: some Scene {
        WindowGroup {
            if selectedLanguage == nil {
                LanguageSelectionView()
            } else {
                ContentView()
            }
        }
    }
}
