//
//	PlayerInteractor.swift
// 	SoundCloudPlayer
//

import Foundation
import AVKit
import MediaPlayer

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
    var nowPlayingInfo: [String: Any] = [:]
    var presenter: PlayerPresentationLogic?
    
    private let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    private var headers: [String: String]!
    
    init() {
        setupMediaPlayerCommandCenter()
    }
    
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
        presenter?.presentDurationState(passed: 0, left: 0, ratio: 0)
        var asset: AVURLAsset
        
        if let localUrl = URL(string: track.streamUrl, relativeTo: AppDirectories.documents.rawValue), localUrl.isFileURL {
            asset = AVURLAsset(url: localUrl)
        } else {
            guard let url = URL(string: track.streamUrl),
                let headers = headers else { return }
            asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        }
        
        let playerItem = AVPlayerItem(asset: asset)
        
        presenter?.presentTrack(track)
        setupMediaPlayerInfoCenter(with: track)
        checkNearbyTracks()
        
        observeTrackDuration()
        observeTrackSeek(duration: Double(track.durationSeconds))
        
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
            setPlaybackProperties(elapsed: player.currentTime(), rate: 1)
            presenter?.presentPlayingState(isPlaying: true)
        } else {
            player.pause()
            presenter?.presentPlayingState(isPlaying: false)
            setPlaybackProperties(elapsed: player.currentTime(), rate: 0)
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

// MARK: - Work with system Media Player
extension PlayerInteractor {
    private func setupMediaPlayerCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] _ in
            self.changePlayingState()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] _ in
            self.changePlayingState()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] _ in
            self.playNextTrack()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] _ in
            self.playPreviuosTrack()
            return .success
        }
    }
    
    private func setupMediaPlayerInfoCenter(with track: Track) {
        nowPlayingInfo.removeAll()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = track.title
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = track.durationSeconds
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Cloud Music"
         
        MPNowPlayingInfoCenter.default().nowPlayingInfo = self.nowPlayingInfo
    }
    
    private func setPlaybackProperties(elapsed: CMTime, rate: Float) {
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(elapsed)
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func observeTrackSeek(duration: Double) {
        setPlaybackProperties(elapsed: player.currentTime(), rate: 0)
        let time = CMTime(seconds: duration, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { [weak self] _ in
            guard let self = self else { return }
            self.setPlaybackProperties(elapsed: self.player.currentTime(), rate: 1)
        }
    }
}
