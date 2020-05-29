//
//	PlayerModel.swift
// 	SoundCloudPlayer
//

import Foundation

enum TrackList {
    enum FetchTracks {
        struct Request {}
        struct Response {
            let trackList: [Track]
        }
        struct ViewModel {
            struct DisplayedTrack {
                let id: Int
                let title: String
                let duration: String
                let artworkUrl: String?
            }
            let displayedTracks: [DisplayedTrack]
        }
    }
}
