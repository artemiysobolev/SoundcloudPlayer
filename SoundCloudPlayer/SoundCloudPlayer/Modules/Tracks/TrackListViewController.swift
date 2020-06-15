//
//	TracksView.swift
// 	SoundCloudPlayer
//

import UIKit

class TrackListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    weak private var trackListView: TrackListViewProtocol?
    private let searchController = UISearchController()
    private var timer: Timer?

    var trackList: [TrackViewData] = []
    var presenter: TrackListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        configureSearchController()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if searchBarIsEmpty {
            presenter?.getTrackList()
        }
    }
    
    private func configureTableView() {
        let cellNib = UINib(nibName: "TrackCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TrackCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - View protocol for MVP module

extension TrackListViewController: TrackListViewProtocol {
    func setTrackList(trackList: [TrackViewData]) {
        self.trackList = trackList
        tableView.reloadData()
    }
}

// MARK: - Table View

extension TrackListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.cellIdentifier) as? TrackCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: trackList[indexPath.row])
        cell.tapAction = {
            self.presenter?.cellButtonTapped(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.endEditing(true)
        presenter?.showPlayer(from: indexPath.row)
    }
}

// MARK: - Search Controller

extension TrackListViewController: UISearchResultsUpdating {
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type artist name or song title"
        searchController.searchBar.tintColor = UIColor(named: "SoundcloudOrange")
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty {
            presenter?.getTrackList()
        } else {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                self.presenter?.searchTracks(withBody: searchController.searchBar.text!)
            })
        }
    }
    
}
