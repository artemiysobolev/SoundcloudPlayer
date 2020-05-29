//
//	TracksView.swift
// 	SoundCloudPlayer
//

import UIKit

class TrackListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    weak private var trackListView: TrackListViewProtocol?
    var trackList: [TrackViewData] = []
    var filteredTrackList: [TrackViewData] = []
    var presenter: TrackListPresenterProtocol?
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        configureSearchController()
        presenter?.getTrackList()
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
        if isFiltering {
            return filteredTrackList.count
        }
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TrackListTableViewCell
        if isFiltering {
            cell.configureCell(with: filteredTrackList[indexPath.row])
        } else {
            cell.configureCell(with: trackList[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            print(filteredTrackList[indexPath.row].title)
            presenter?.showPlayer(with: [])
        } else {
            print(trackList[indexPath.row].title)
            presenter?.showPlayer(with: [])
        }
    }
}

// MARK: - Search Controller

extension TrackListViewController: UISearchResultsUpdating {
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type genre or song title"
        searchController.searchBar.tintColor = UIColor(named: "SoundcloudOrange")
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredTrackList = trackList.filter({ (track: TrackViewData) -> Bool in
            if let genre = track.genre {
                return (track.title.lowercased().contains(searchText.lowercased()) || genre.lowercased().contains(searchText.lowercased()))
            } else {
                return (track.title.lowercased().contains(searchText.lowercased()))
            }
        })
        
        tableView.reloadData()
    }
    
}
