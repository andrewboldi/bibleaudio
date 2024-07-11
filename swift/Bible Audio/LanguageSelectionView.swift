//
//  LanguageSelectionView.swift
//  Bible Audio
//
//  Created by Andrew Boldi on 7/8/24.
//

import SwiftUI

struct LanguageSelectionView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var isPressed: Bool = false
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    let languages = ["English", "Armenian"]
    
    var body: some View {
        NavigationStack {
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
                }, label: {
                    Text("Confirm")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                .navigationDestination(isPresented: $isPressed) {
                    AudioView()
                }
            }
        }
    }
}

#Preview {
    LanguageSelectionView()
}
