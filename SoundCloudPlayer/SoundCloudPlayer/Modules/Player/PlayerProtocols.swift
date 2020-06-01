//
//	PlayerProtocols.swift
// 	SoundCloudPlayer
//

import Foundation

protocol PlayerDispayLogic: class {
    func displayTrack(_ track: DisplayedTrack)
    func displayDurationState(passed: String, left: String)
    func togglePlayButtonImage(isPlaying: Bool)
}

protocol PlayerBusinessLogic {
    func setTrack(track: Track)
    func changePlayingState()
}

protocol PlayerDataStore {
    var trackList: [Track]? { get set }
    var token: String? { get set }
}

protocol PlayerPresentationLogic {
    func presentTrack(_ track: Track)
    func presentPlayingState(isPlaying: Bool)
    func presentDurationState(passed: Int, left: Int)
}

protocol PlayerRoutingLogic {
    
}

protocol PlayerDataPassing {
    
}
