//
//  AudioPlayer.swift
//  Bible Audio
//
//  Created by Andrew Boldi on 7/8/24.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?
    private var currentTrackIndex = 0
    private var trackURLs: [URL] = []
    @Published var isPlaying = false

    override init() {
        super.init()
        loadTrackURLs()
        prepareToPlay()
    }

    func loadTrackURLs() {
        // Load your track URLs here. For simplicity, we'll use some dummy URLs.
        // In a real app, you'd fetch these from your server or local storage.
        for i in 0...259 { // 260 chapters in the NT 
            if let url = URL(string: "https://github.com/Polydynamical/bibleaudio/raw/main/audio/mp3/ESV/chapters/\(String(format: "%03d", arguments: [i])).mp3") {
                trackURLs.append(url)
            }
        }
    }

    func prepareToPlay() {
        guard !trackURLs.isEmpty else { return }
        downloadTrack(at: currentTrackIndex)
    }

    func downloadTrack(at index: Int) {
        let url = trackURLs[index]
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL else { return }
            self.playTrack(from: localURL)
            // Delete the local file after playback
            try? FileManager.default.removeItem(at: localURL)
        }
        task.resume()
    }

    func playTrack(from url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
            isPlaying = true
        } catch {
            print("Error playing track: \(error)")
        }
    }

    func togglePlayPause() {
        if player?.isPlaying == true {
            player?.pause()
            isPlaying = false
        } else {
            player?.play()
            isPlaying = true
        }
    }
}

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentTrackIndex += 1
        if currentTrackIndex >= trackURLs.count {
            currentTrackIndex = 0
        }
        prepareToPlay()
    }
