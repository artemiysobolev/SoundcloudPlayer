//
//	TracksPresenter.swift
// 	SoundCloudPlayer
//

import UIKit

class TrackListPresenter {
    var userId: String!
    var token: String!
    
    weak var trackListView: TrackListView?
    let networkService: TrackListNetworkServiceProtocol
    
    init(networkService: TrackListNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getTrackList() {
        networkService.getUserTrackList(token: token, userId: userId) { [weak self] trackList in
            guard let self = self else { return }
            var tracksForView: [TrackViewData] = []
            for track in trackList {
                tracksForView.append(TrackViewData(id: track.id,
                                                   title: track.title,
                                                   genre: track.genre,
                                                   duration: "mm:ss"))
            }
            DispatchQueue.main.async {
                self.trackListView?.setTrackList(trackList: tracksForView)
            }
        }
    }
}

struct TrackViewData {
    let id: Int
    let title: String
    let genre: String
    let duration: String
}
