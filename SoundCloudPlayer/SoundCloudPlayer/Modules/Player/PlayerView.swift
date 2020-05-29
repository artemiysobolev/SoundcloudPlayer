//
//	PlayerView.swift
// 	SoundCloudPlayer
//

import UIKit

class PlayerView: UIView {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var currentDurationLabel: UILabel!
    @IBOutlet weak var remainingDurationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    }
        
}
