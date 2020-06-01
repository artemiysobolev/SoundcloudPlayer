//
//	PlayerInteractor.swift
// 	SoundCloudPlayer
//

import Foundation
import AVKit

class PlayerInteractor: PlayerDataStore, PlayerBusinessLogic {
    
    var trackList: [Track]?
    var presenter: PlayerPresentationLogic?
    var token: String? {
        didSet {
            headers = ["Authorization": "OAuth \(token ?? "")"]
        }
    }
    
    private let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    private var headers: [String: String]!
    
    func setTrack(track: Track) {
        guard let urlString = track.streamUrl,
            let url = URL(string: urlString),
            let headers = headers else { return }
        presenter?.presentTrack(track)
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        let playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func changePlayingState() {
        if player.timeControlStatus == .paused {
            player.play()
            presenter?.presentNewPlayButtonStatus(isPlaying: true)
        } else {
            player.pause()
            presenter?.presentNewPlayButtonStatus(isPlaying: false)
        }
    }
}
