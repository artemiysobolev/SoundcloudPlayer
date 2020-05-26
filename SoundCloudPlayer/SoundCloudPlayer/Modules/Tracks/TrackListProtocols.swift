//
//	TracksProtocols.swift
// 	SoundCloudPlayer
//

import UIKit

protocol TrackListNetworkServiceProtocol: class {
    func getUserTrackList(token: String, userId: String, complectionHandler: @escaping([Track]) -> Void)
}

protocol TrackListView: class {
    func setTrackList(trackList: [TrackViewData])
}
