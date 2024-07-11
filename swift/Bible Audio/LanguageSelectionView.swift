//
//  LanguageSelectionView.swift
//  Bible Audio
//
//  Created by Andrew Boldi on 7/8/24.
//

import SwiftUI

struct LanguageSelectionView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @AppStorage("selectedLanguage") var selectedLanguageStore = "English"
    @State var isPressed: Bool = false
    @State var selectedLanguage: String = "English"
    
    let languages = ["English", "Armenian"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select your language")
                    .font(.largeTitle)
                    .padding()
                
                Picker(selection: $selectedLanguage, label: Text("Language")) {
                    ForEach(languages, id: \.self) { language in
                        Text(language).tag(language)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                
                Button(action: {
                    isPressed = true
                    isWelcomeScreenOver = true
                    selectedLanguageStore = selectedLanguage
                }, label: {
                    Text("Confirm")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                NavigationLink(destination: AudioView().navigationBarHidden(true), isActive: $isPressed) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    LanguageSelectionView()
}
