//
//  LanguageSelectionView.swift
//  Bible Audio
//
//  Created by Andrew Boldi on 7/8/24.
//

import SwiftUI

struct LanguageSelectionView: View {
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    let languages = ["English", "Armenian"]
    
    var body: some View {
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
            
            if selectedLanguage != nil {
                Button(action: {
                    // Action to dismiss this view and proceed
                }) {
                    Text("Confirm")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageSelectionView()
    }
}
