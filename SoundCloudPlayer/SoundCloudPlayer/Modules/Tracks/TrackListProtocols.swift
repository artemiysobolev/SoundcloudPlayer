//
//	TracksProtocols.swift
// 	SoundCloudPlayer
//

import UIKit

protocol TrackListNetworkServiceProtocol: class {
    func getUserTrackList(token: String, complectionHandler: @escaping(Result<[Track], Error>) -> Void)
}

protocol TrackListViewProtocol: class {
    var presenter: TrackListPresenterProtocol? { get set }
    func setTrackList(trackList: [TrackViewData])
}

protocol TrackListPresenterProtocol: class {
    var view: TrackListViewProtocol? { get set }
    var networkService: TrackListNetworkServiceProtocol? { get set }
    var token: String { get set }
    func getTrackList()
}
