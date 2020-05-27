//
//	TrackTableViewCell.swift
// 	SoundCloudPlayer
//

import UIKit

class TrackListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artworkImageView: NetworkUIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func configureCell(with track: TrackViewData) {
        if let artworkUrl = track.artworkUrl {
            artworkImageView.loadImageUsingUrlString(urlString: artworkUrl)
        } else {
            artworkImageView.image = UIImage(named: "emptyArtwork")
        }
        if let genre = track.genre {
            genreLabel.text = genre
        }
        titleLabel.text = track.title
        durationLabel.text = track.duration
    }
}
