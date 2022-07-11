//
//  SoundandHaptics.swift
//  Travel Companion
//
//  Created by Spencer Goldberg on 7/1/22.
//

import AVFoundation
import CoreHaptics
import UIKit

struct SoundsAndHaptics {
    
    private static let allowSound = UserDefaults.standard.bool(forKey: "play_sound")
    private static let allowHaptic = UserDefaults.standard.bool(forKey: "allow_haptic")
    private static var player: AVAudioPlayer?

    enum PlaybackError: Error {
        case invalidPath
        case soundsDisabled
        case hapticsDisabled
        case audioPlayerNotInitialized
    }
    
    /// Sets up the AVAudioSession for specifally playing a sound effect.
    /// Currently only works with wav file extensions.
    /// - Parameters:
    ///     - soundFile: A wav file
    ///     - volume: The volume to play the soundFile at. Can be any float value in between 0 and 1
    static func playSound(soundFile: String, volume: Float = 0.08) throws {
        guard allowSound else { throw PlaybackError.soundsDisabled }
        
        guard let url = Bundle.main.url(forResource: soundFile, withExtension: "wav") else {
            throw PlaybackError.invalidPath
        }
        
        try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
        
        guard let player = player else { throw PlaybackError.audioPlayerNotInitialized }
        
        player.volume = volume
        player.play()
    }
    
    static func playHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) throws {
        guard allowHaptic else { throw PlaybackError.hapticsDisabled }
        
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    static func playVibration(type: UINotificationFeedbackGenerator.FeedbackType = .success) throws {
        guard allowHaptic else { throw PlaybackError.hapticsDisabled }
        
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    static func playSoundWithHaptic(soundFile: String, style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) throws {
        try playSound(soundFile: soundFile)
        try playHaptic(style: style)
    }
    
    static func playSoundWithVibration(soundFile: String, type: UINotificationFeedbackGenerator.FeedbackType = .success) throws {
        try playSound(soundFile: soundFile)
        try playVibration(type: type)
    }
}

