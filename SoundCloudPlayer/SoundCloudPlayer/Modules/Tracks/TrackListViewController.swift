//
//	TracksView.swift
// 	SoundCloudPlayer
//

import UIKit

class TrackListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    weak private var trackListView: TrackListViewProtocol?
    var trackList: [TrackViewData] = []
    var presenter: TrackListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getTrackList()
    }
}

extension TrackListViewController: TrackListViewProtocol {
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
        cell.configureCell(with: trackList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
