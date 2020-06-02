//
//    TracksPresenter.swift
//     SoundCloudPlayer
//

import UIKit

class TrackListPresenter: NSObject {
    
    weak var view: TrackListViewProtocol?
    weak var tabBarDelegate: PlayerViewAppearanceDelegate?
    var token: String
    var networkService: TrackListNetworkServiceProtocol?
    var currentTrackList: [Track]?
    
    init(token: String) {
        self.token = token
    }
    
    private func convertTrackListForView(_ trackList: [Track]) -> [TrackViewData] {
        let tracksForView = trackList.map({ track -> TrackViewData in
            return TrackViewData(title: track.title,
                                 genre: track.genre,
                                 duration: track.duration.convertMillisecondsDurationToString(),
                                 artworkUrl: track.artworkUrl)
        })
        return tracksForView
    }
}

extension TrackListPresenter: TrackListPresenterProtocol {
    
    func searchTracks(withBody body: String) {
        networkService?.tracksSearchRequest(token: token, searchBody: body, completionHandler: { [weak self] result in
            guard let self = self else { return }
            var tracksForView: [TrackViewData] = []
            switch result {
            case .success(let trackList):
                self.currentTrackList = trackList
                tracksForView = self.convertTrackListForView(trackList)
            case .failure(let error):
                print("Some error with JSON: ", error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.view?.setTrackList(trackList: tracksForView)
            }
        })
    }
    
    func showPlayer(from trackIndex: Int) {
        guard let currentTrackList = currentTrackList else { return }
        let tracksQueue: [Track] = Array(currentTrackList[trackIndex ..< currentTrackList.count])
        tabBarDelegate?.presentFullPlayerScreen(tracksQueue: tracksQueue)
    }
    
    func getUserTrackList() {
        networkService?.getUserTrackList(token: token) { [weak self] result in
            guard let self = self else { return }
            var tracksForView: [TrackViewData] = []
            switch result {
            case .success(let trackList):
                self.currentTrackList = trackList
                tracksForView = self.convertTrackListForView(trackList)
            case .failure(let error):
                print("Some error with JSON: ", error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.view?.setTrackList(trackList: tracksForView)
            }
        }
    }
}
