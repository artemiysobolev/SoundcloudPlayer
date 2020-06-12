//
//	TrackTableViewCell.swift
// 	SoundCloudPlayer
//

import UIKit

class TrackCell: UITableViewCell {
    static let cellIdentifier = "TrackCell"

    @IBOutlet weak var artworkImageView: CustomUIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var cacheButton: UIButton!
    var tapAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with track: TrackViewData) {
        if let artworkUrl = track.artworkUrl {
            artworkImageView.loadImageUsingUrlString(urlString: artworkUrl)
        } else {
            artworkImageView.image = UIImage(named: "emptyArtwork")
        }
        if let genre = track.genre {
            genreLabel.text = genre
        }
        switch track.cacheStatus {
        case .cached:
            cacheButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cacheButton.isEnabled = false
        case .notCached:
            cacheButton.setImage(UIImage(systemName: "plus"), for: .normal)
            cacheButton.isEnabled = true
        case .inCachedLibrary:
            cacheButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            cacheButton.isEnabled = true
        }
        titleLabel.text = track.title
        durationLabel.text = track.duration
    }
    
    @IBAction func cacheButtonTapped(_ sender: UIButton) {
        cacheButton.isEnabled = false
        tapAction?()
    }
}
