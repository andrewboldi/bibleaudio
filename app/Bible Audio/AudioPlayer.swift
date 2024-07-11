//
//  AudioPlayer.swift
//  Bible Audio
//
//  Created by Andrew Boldi on 7/8/24.
//

import Foundation
import AVFoundation
import SwiftUI

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?
    private var trackURLs: [URL] = []
    @Published var isPlaying = false

    // persist currentTrackIndex after relaunch via UserDefaults
    private var currentTrackIndex: Int {
        get {
            UserDefaults.standard.integer(forKey: "currentTrackIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentTrackIndex")
        }
    }

    override init() {
        super.init()
        configureAudioSession()
        loadTrackURLs()
        prepareToPlay()
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up AVAudioSession: \(error)")
        }
    }

    func loadTrackURLs() {
        // Load your track URLs here. For simplicity, we'll use some dummy URLs.
        // In a real app, you'd fetch these from your server or local storage.
        let version = switch UserDefaults.standard.string(forKey: "selectedLanguage") {
            case "English":
                "ESV"
            case "Armenian":
                "WA2017"
            default:
                "ESV"
        }

        for i in 0...259 { // 260 chapters in the NT 
            if let url = URL(string: "https://github.com/Polydynamical/bibleaudio/raw/main/audio/mp3/\(version)/chapters/\(String(format: "%03d", arguments: [i])).mp3") {
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
        if isPlaying == true {
            player?.pause()
            isPlaying = false
        } else {
            player?.play()
            isPlaying = true
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentTrackIndex += 1
        if currentTrackIndex >= trackURLs.count {
            currentTrackIndex = 0
        }
        prepareToPlay()
    }
}
