//
//	PlayerPresenter.swift
// 	SoundCloudPlayer
//

import Foundation

class PlayerPresenter: PlayerPresentationLogic {
    weak var view: PlayerDispayLogic?
    
    func presentTrack(_ track: Track) {
        let displayedTrack = DisplayedTrack(title: track.title,
                                            duration: track.duration.convertMillisecondsDurationToString(),
                                            artworkUrl: track.artworkUrl?.replacingOccurrences(of: "large", with: "crop"))
        view?.displayTrack(displayedTrack)
    }
    
    func presentPlayingState(isPlaying: Bool) {
        view?.togglePlayButtonImage(isPlaying: isPlaying)
    }
    
    func presentDurationState(passed: Int, left: Int) {
        view?.displayDurationState(passed: (passed).convertMillisecondsDurationToString(),
                                   left: "-\((left).convertMillisecondsDurationToString())")
    }
}
