//
//	PlayerProtocols.swift
// 	SoundCloudPlayer
//

import Foundation

protocol PlayerDispayLogic: class {
    func displayTrack(_ track: DisplayedTrack)
    func togglePlayButtonImage(isPlaying: Bool)
    func displayDurationState(passed: String, left: String, ratio: Float)
    func displayEnabledNavigationButtons(isPreviousEnabled: Bool, isNextEnabled: Bool)
}

protocol PlayerBusinessLogic {
    func setTrack(track: Track)
    func changePlayingState()
    func changeTrackTimeState(with value: Float)
    func changeVolume(with value: Float)
    func playPreviuosTrack()
    func playNextTrack()
}

protocol PlayerDataStore {
    var trackList: [Track]! { get set }
    var token: String! { get set }
}

protocol PlayerPresentationLogic {
    func presentTrack(_ track: Track)
    func presentPlayingState(isPlaying: Bool)
    func presentDurationState(passed: Int, left: Int, ratio: Float)
    func presentEnabledNavigationButtons(previous: Bool, next: Bool)
}

protocol PlayerRoutingLogic {
    
}

protocol PlayerDataPassing {
    
}
