//
//	CachedLibraryPresenter.swift
// 	SoundCloudPlayer
//

import Foundation

class CachedLibraryPresenter: TrackListPresenterProtocol {
    
    let coreDataService = CoreDataService.shared
    var networkService: TrackListNetworkServiceProtocol?
    weak var view: TrackListViewProtocol?
    weak var tabBarDelegate: PlayerViewAppearanceDelegate?
    var trackList: [CachedTrack] = []
    
    func getTrackList() {
        trackList = coreDataService.fetchTracks()
        view?.setTrackList(trackList: convertTrackListForView(trackList))
    }
    
    func searchTracks(withBody body: String) {
        guard !body.isEmptyOrWhitespace() else {
            view?.setTrackList(trackList: convertTrackListForView(trackList))
            return
        }
        let filteredTrackList = trackList.filter { track -> Bool in
            return track.title!.lowercased().contains(body.lowercased())
        }
        trackList = filteredTrackList
        view?.setTrackList(trackList: convertTrackListForView(filteredTrackList))
    }
    
    func showPlayer(fromTrackIndex trackIndex: Int) {
        let tracksQueue = Array(trackList[trackIndex ..< trackList.count]).map { track -> Track in
            return Track(id: Int(track.id),
                         title: track.title ?? "",
                         genre: track.genre,
                         duration: Int(track.duration),
                         artworkUrl: track.artworkImagePath,
                         streamUrl: track.audioFilePath ?? "")
        }
        tabBarDelegate?.presentFullPlayerScreen(tracksQueue: tracksQueue)
    }
    
    func cellButtonTapped(index: Int) {
        let track = trackList[index]
        coreDataService.removeTrack(track)
        getTrackList()
    }
    
    private func convertTrackListForView(_ trackList: [CachedTrack]) -> [TrackViewData] {
        let tracksForView = trackList.map { track -> TrackViewData in
            return  TrackViewData(title: track.title ?? "",
                                  genre: track.genre,
                                  duration: Int(track.duration).convertMillisecondsDurationToString(),
                                  artworkUrl: track.artworkImagePath,
                                  cacheStatus: .inCachedLibrary)
        }
        return tracksForView
    }
    
}
