//
//	PlayerView.swift
// 	SoundCloudPlayer
//

import UIKit
import AVKit

class PlayerView: UIView {
    
    @IBOutlet weak var minimizedPlayerView: UIView!
    @IBOutlet weak var minimizedPlayButton: UIButton!
    @IBOutlet weak var minimizedNextButton: UIButton!
    @IBOutlet weak var minimizedArtworkImageView: NetworkUIImageView!
    @IBOutlet weak var minimizedTitleLabel: UILabel!
    
    @IBOutlet weak var fullScreenPlayerStackView: UIStackView!
    @IBOutlet weak var artworkImageView: NetworkUIImageView!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var remainingDurationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var interactor: (PlayerBusinessLogic & PlayerDataStore)?
    var router: PlayerRoutingLogic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        remove thumb image and slider moving ability
//        makeDurationSliderInactive()
        setupModule()
        setupGestures()
    }
    
    // MARK: - IBActions
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        router?.minimizePlayerScreen()
    }
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
        interactor?.changeTrackTimeState(with: durationSlider.value)
    }
    @IBAction func volumeSliderValueChanged(_ sender: UISlider) {
        interactor?.changeVolume(with: volumeSlider.value)
    }
    @IBAction func previousTrackButtonTapped(_ sender: UIButton) {
        interactor?.playPreviuosTrack()
    }
    @IBAction func nextTrackButtonTapped(_ sender: UIButton) {
        interactor?.playNextTrack()
    }
    @IBAction func playButtonTapped(_ sender: UIButton) {
        interactor?.changePlayingState()
    }
    
    // MARK: - Setup VIP module
    
    private func setupModule() {
        let view = self
        let interactor = PlayerInteractor()
        let presenter = PlayerPresenter()
        let router = PlayerRouter()
        view.interactor = interactor
        view.router = router
        interactor.presenter = presenter
        presenter.view = view
    }
    
    // MARK: - Work with gestures
    
    private func setupGestures() {
        minimizedPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(minimizedViewTapHandle)))
    }
    
    @objc private func minimizedViewTapHandle() {
        router?.presentFullPlayerScreen()
    }
    
    // MARK: - Private methods
    
    private func makeDurationSliderInactive() {
        durationSlider.isUserInteractionEnabled = false
        durationSlider.setThumbImage(UIImage(), for: .normal)
    }
    
}

// MARK: - DispayLogic protocol

extension PlayerView: PlayerDispayLogic {
    
    func togglePlayButtonImage(isPlaying: Bool) {
        if isPlaying {
            let pauseImage = UIImage(systemName: "pause.fill")
            playButton.setImage(pauseImage, for: .normal)
            minimizedPlayButton.setImage(pauseImage, for: .normal)
        } else {
            let playImage = UIImage(systemName: "play.fill")
            minimizedPlayButton.setImage(playImage, for: .normal)
            playButton.setImage(playImage, for: .normal)
        }
    }
    
    func displayDurationState(passed: String, left: String, ratio: Float) {
        currentDurationLabel.text = passed
        remainingDurationLabel.text = left
        durationSlider.value = ratio
    }
    
    func displayEnabledNavigationButtons(isPreviousEnabled: Bool, isNextEnabled: Bool) {
        previousButton.isEnabled = isPreviousEnabled
        nextButton.isEnabled = isNextEnabled
        minimizedNextButton.isEnabled = isNextEnabled
    }
    
    func displayTrack(_ track: DisplayedTrack) {
        if let artworkUrl = track.artworkUrl {
            artworkImageView.loadImageUsingUrlString(urlString: artworkUrl)
            minimizedArtworkImageView.loadImageUsingUrlString(urlString: artworkUrl)
        } else {
            artworkImageView.image = #imageLiteral(resourceName: "emptyArtwork")
        }
        remainingDurationLabel.text = "-\(track.duration)"
        titleLabel.text = track.title
        minimizedTitleLabel.text = track.title
    }
}
