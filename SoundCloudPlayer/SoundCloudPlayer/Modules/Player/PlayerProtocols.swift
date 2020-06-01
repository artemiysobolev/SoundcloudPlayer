//
//	PlayerProtocols.swift
// 	SoundCloudPlayer
//

import Foundation

protocol PlayerDispayLogic: class {
    func displayTrack(_ track: DisplayedTrack)
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
    func presentNewPlayButtonStatus(isPlaying: Bool)
}

protocol PlayerRoutingLogic {
    
}

protocol PlayerDataPassing {
    
}
