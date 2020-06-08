//
//	PlayerInteractor.swift
// 	SoundCloudPlayer
//

import Foundation
import AVKit

class PlayerInteractor: PlayerDataStore {

    var trackList: [Track]! {
        didSet {
            currentTrackIndex = 0
            shuffledTrackList = nil
        }
    }
    var shuffledTrackList: [Track]? {
        didSet {
            presenter?.presentShufflingState(isShuffled: shuffledTrackList != nil)
            shuffledCurrentTrackIndex = 0
        }
    }
    var isShuffleActive: Bool {
        return shuffledTrackList != nil
    }
    
    var token: String! {
        didSet {
            headers = ["Authorization": "OAuth \(token ?? "")"]
        }
    }
    var currentTrackIndex = 0
    var shuffledCurrentTrackIndex = 0
    var presenter: PlayerPresentationLogic?

    private let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    private var headers: [String: String]!
    
    // MARK: - Private methods
    private func observeTrackDuration() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self,
                let duration  = self.player.currentItem?.duration,
                !duration.isIndefinite else { return }
            
            let passedMs = Int(time.seconds) * 1000
            let leftMs = Int(duration.seconds) * 1000 - passedMs
            guard leftMs != 0 else {
                self.playNextTrack()
                return
            }
            let ratio = self.getDurationRatio()
            self.presenter?.presentDurationState(passed: passedMs, left: leftMs, ratio: ratio)
        }
    }
    
    private func getDurationRatio() -> Float {
        let passed = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        return Float(passed / duration)
    }
    
    private func checkNearbyTracks() {
        let (list, index) = shuffledTrackList != nil ? (shuffledTrackList!, shuffledCurrentTrackIndex) : (trackList!, currentTrackIndex)
        let leftTrackEnabled = index == 0 ? false : true
        let rightTrackEnabled = index == list.count - 1 ? false : true
        presenter?.presentEnabledNavigationButtons(previous: leftTrackEnabled, next: rightTrackEnabled)
    }
}

// MARK: - BusinessLogic protocol
extension PlayerInteractor: PlayerBusinessLogic {
    
    func setTrack(track: Track) {
        guard let urlString = track.streamUrl,
            let url = URL(string: urlString),
            let headers = headers else { return }
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        let playerItem = AVPlayerItem(asset: asset)
        
        presenter?.presentTrack(track)
        checkNearbyTracks()
        
        observeTrackDuration()
        player.replaceCurrentItem(with: playerItem)
        player.play()
        presenter?.presentPlayingState(isPlaying: true)
    }
    
    func changeVolume(with value: Float) {
        player.volume = value
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
    
    func playPreviuosTrack() {
        let usingTrackList = isShuffleActive ? shuffledTrackList : trackList
        let usingIndex = isShuffleActive ? shuffledCurrentTrackIndex : currentTrackIndex
        
        let previousIndex = usingIndex - 1
        guard let trackList = usingTrackList,
            previousIndex >= 0 else { return }
        
        setTrack(track: trackList[previousIndex])
        
        if isShuffleActive {
            shuffledCurrentTrackIndex -= 1
        } else {
            currentTrackIndex -= 1
        }
        
        checkNearbyTracks()
    }
    
    func playNextTrack() {
        let usingTrackList = isShuffleActive ? shuffledTrackList : trackList
        let usingIndex = isShuffleActive ? shuffledCurrentTrackIndex : currentTrackIndex
        
        let nextIndex = usingIndex + 1
        guard let trackList = usingTrackList,
            nextIndex < trackList.count else { return }
        
        setTrack(track: trackList[nextIndex])
        
        if isShuffleActive {
            shuffledCurrentTrackIndex += 1
        } else {
            currentTrackIndex += 1
        }
        
        checkNearbyTracks()
    }
    
    func changeTrackTimeState(with value: Float) {
        guard let durationSeconds = player.currentItem?.duration else { return }
        let seekTimeSeconds = Float64(value) * CMTimeGetSeconds(durationSeconds)
        let seekTime = CMTimeMakeWithSeconds(seekTimeSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    func changeShuffling() {
        
        if isShuffleActive {
            guard let index = trackList.firstIndex(of: shuffledTrackList![shuffledCurrentTrackIndex]) else { return }
            currentTrackIndex = index
            shuffledTrackList = nil
        } else {
            let nextTrackIndex = currentTrackIndex + 1
            guard nextTrackIndex < trackList.count else { return }
            
            shuffledTrackList = Array(trackList[0...currentTrackIndex])
            shuffledTrackList?.append(contentsOf: Array(trackList[nextTrackIndex ..< trackList.count]).shuffled())
            shuffledCurrentTrackIndex = currentTrackIndex
        }
        
        checkNearbyTracks()
    }
    
}
