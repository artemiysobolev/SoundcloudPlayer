//
//	PlayerPresenter.swift
// 	SoundCloudPlayer
//

import Foundation

class PlayerPresenter: PlayerPresentationLogic {

    weak var view: PlayerDispayLogic?
    
    func presentTrack(_ track: Track) {
        let displayedTrack = DisplayedTrack(title: track.title,
                                            duration: track.duration,
                                            artworkUrl: track.artworkUrl?.replacingOccurrences(of: "large", with: "crop"))
        view?.displayTrack(displayedTrack)
    }
    
    func presentNewPlayButtonStatus(isPlaying: Bool) {
        view?.togglePlayButtonImage(isPlaying: isPlaying)
    }
}
