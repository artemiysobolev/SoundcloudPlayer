//
//	TracksView.swift
// 	SoundCloudPlayer
//

import UIKit

class TrackListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    weak private var trackListView: TrackListView?
    var trackList: [TrackViewData] = []
    let trackListPresenter = TrackListPresenter(networkService: NetworkService())
}

extension TrackListViewController: TrackListView {
    func setTrackList(trackList: [TrackViewData]) {
        self.trackList = trackList
        tableView.reloadData()
    }
}

extension TrackListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TrackListTableViewCell
        cell.titleLabel.text = trackList[indexPath.row].title
        cell.genreLabel.text = trackList[indexPath.row].genre
        cell.durationLabel.text = trackList[indexPath.row].duration
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
