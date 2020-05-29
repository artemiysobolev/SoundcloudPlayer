//
//	PlayerView.swift
// 	SoundCloudPlayer
//

import UIKit

class PlayerView: UIView, PlayerDispayLogic {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var remainingDurationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    var interactor: (PlayerBusinessLogic & PlayerDataStore)?
    var router: PlayerRoutingLogic?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
    }
    @IBAction func volumeSliderValueChanged(_ sender: UISlider) {
    }
    @IBAction func previousTrackButtonTapped(_ sender: UIButton) {
    }
    @IBAction func nextTrackButtonTapped(_ sender: UIButton) {
    }
    @IBAction func playButtonTapped(_ sender: UIButton) {
        print(interactor?.trackList.map({ track -> String in
            return track.title
        }) ?? "")
    }
    
    private func setup() {
        let view = self
        let interactor = PlayerInteractor()
        let presenter = PlayerPresenter()
        let router = PlayerRouter()
        view.interactor = interactor
        view.router = router
        interactor.presenter = presenter
        presenter.view = view
    }
}
