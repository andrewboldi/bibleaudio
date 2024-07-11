//
//  MainView.swift
//  Bible Audio
//
//  Created by Andrew Boldi on 7/10/24.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var checkWelcomeScreen: Bool = false
    
    
    var body: some View {
        VStack {
            if checkWelcomeScreen {
                AudioView()
            } else {
                LanguageSelectionView()
            }
        }
        .onAppear {
            checkWelcomeScreen = isWelcomeScreenOver
        }
    }
}

#Preview {
    MainView()
}
