//
//    TracksPresenter.swift
//     SoundCloudPlayer
//

import UIKit

class TrackListPresenter: NSObject {
    var token: String
    
    init(token: String) {
        self.token = token
    }
    
    weak var view: TrackListViewProtocol?
    var networkService: TrackListNetworkServiceProtocol?
    
}

extension TrackListPresenter: TrackListPresenterProtocol {
    
    func searchTracks(withBody body: String) {
        networkService?.tracksSearchRequest(token: token, searchBody: body, completionHandler: { [weak self] result in
            guard let self = self else { return }
            var tracksForView: [TrackViewData] = []
            switch result {
            case .success(let trackList):
                tracksForView = self.convertTrackListForView(trackList)
            case .failure(let error):
                print("Some error with JSON: ", error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.view?.setTrackList(trackList: tracksForView)
            }
        })
    }
    
    func showPlayer(with trackList: [TrackViewData]) {
        guard let window = UIWindow.key,
            let playerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as? PlayerView else {
                return
        }
        let trackListForPlayer = trackList.map({ track -> Track in
            return Track(id: track.id,
                         title: track.title,
                         genre: track.genre,
                         duration: 23343,
                         artworkUrl: track.artworkUrl)
        })
        playerView.interactor?.token = token
        playerView.interactor?.trackList = trackListForPlayer
        window.addSubview(playerView)
    }
    
    func getTrackList() {
        networkService?.getUserTrackList(token: token) { [weak self] result in
            guard let self = self else { return }
            var tracksForView: [TrackViewData] = []
            switch result {
            case .success(let trackList):
                tracksForView = trackList.map({ track -> TrackViewData in
                    return TrackViewData(id: track.id,
                                         title: track.title,
                                         genre: track.genre,
                                         duration: track.duration.convertMillisecondsDurationToString(),
                                         artworkUrl: track.artworkUrl)
                })
            case .failure(let error):
                print("Some error with JSON: ", error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.view?.setTrackList(trackList: tracksForView)
            }
        }
    }
    
    private func convertTrackListForView(_ trackList: [Track]) -> [TrackViewData] {
        let tracksForView = trackList.map({ track -> TrackViewData in
            return TrackViewData(id: track.id,
                                 title: track.title,
                                 genre: track.genre,
                                 duration: track.duration.convertMillisecondsDurationToString(),
                                 artworkUrl: track.artworkUrl)
        })
        return tracksForView
    }
}
