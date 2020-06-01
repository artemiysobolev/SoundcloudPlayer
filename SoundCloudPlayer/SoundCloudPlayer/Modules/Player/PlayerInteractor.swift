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
        observeTrackDuration()
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        let playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func changePlayingState() {
        if player.timeControlStatus == .paused {
            player.play()
            presenter?.presentPlayingState(isPlaying: true)
        } else {
            player.pause()
            presenter?.presentPlayingState(isPlaying: false)
        }
    }
    
    func observeTrackDuration() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self,
                let duration  = self.player.currentItem?.duration,
                !duration.isIndefinite else { return }
            
            let passedMs = Int(time.seconds) * 1000
            let leftMs = Int(duration.seconds) * 1000 - passedMs
            self.presenter?.presentDurationState(passed: passedMs, left: leftMs)
        }
    }
}
