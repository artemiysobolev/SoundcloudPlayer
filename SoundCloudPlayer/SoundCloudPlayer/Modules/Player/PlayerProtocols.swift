//
//	PlayerProtocols.swift
// 	SoundCloudPlayer
//

import Foundation

protocol PlayerDispayLogic: class {
    func displayTrack(_ track: DisplayedTrack)
    func togglePlayButtonImage(isPlaying: Bool)
    func displayDurationState(passed: String, left: String, ratio: Float)
    func displayShufflingState(isShuffled: Bool)
    func displayEnabledNavigationButtons(isPreviousEnabled: Bool, isNextEnabled: Bool)
}

protocol PlayerBusinessLogic {
    func setTrack(track: Track)
    func changePlayingState()
    func changeShuffling()
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
    func presentShufflingState(isShuffled: Bool)

}

protocol PlayerRoutingLogic: class {
    var tabBarDelegate: PlayerViewAppearanceDelegate? { get set }
    func presentFullPlayerScreen()
    func minimizePlayerScreen()
}

protocol PlayerDataPassing {
    
}
