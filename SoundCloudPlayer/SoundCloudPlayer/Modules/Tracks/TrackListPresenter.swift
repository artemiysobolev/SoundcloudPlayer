//
//	TracksPresenter.swift
// 	SoundCloudPlayer
//

import UIKit

class TrackListPresenter {
    var token: String
    
    init(token: String) {
        self.token = token
    }
    
    weak var view: TrackListViewProtocol?
    var networkService: TrackListNetworkServiceProtocol?
    
}

//TODO: - Duration convert from Int to String
extension TrackListPresenter: TrackListPresenterProtocol {
    
    func getTrackList() {
        networkService?.getUserTrackList(token: token) { [weak self] trackList in
            guard let self = self else { return }
            var tracksForView: [TrackViewData] = []
            for track in trackList {
                tracksForView.append(TrackViewData(id: track.id,
                                                   title: track.title,
                                                   genre: track.genre,
                                                   duration: "mm:ss"))
            }
            DispatchQueue.main.async {
                self.view?.setTrackList(trackList: tracksForView)
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
