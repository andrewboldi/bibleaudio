//
//  ContentView.swift
//  Bible Audio
//
//  Created by Andrew Boldi on 7/8/24.
//

import SwiftUI

struct AudioView: View {
    @StateObject var audioPlayer = AudioPlayer()
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false

    var colors: [Color] = [.blue, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red]

 
    var body: some View {
        VStack {
            Button(action: {
                audioPlayer.togglePlayPause()
            }) {
                Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundColor(colors.randomElement() ?? .blue)
            }
        }
    }
}

#Preview {
    AudioView()
}
