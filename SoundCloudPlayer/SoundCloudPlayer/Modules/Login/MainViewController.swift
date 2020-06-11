//
//	MainViewController.swift
// 	SoundCloudPlayer
//

import UIKit

protocol PlayerViewAppearanceDelegate: class {
    func minimizePlayerScreen()
    func presentFullPlayerScreen(tracksQueue: [Track]?)
}

class MainViewController: UITabBarController {

    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var fullTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    private let playerView = Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)?.first as? PlayerView
    var token: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        let trackListVC = configureTrackListModule()
        let cachedLibraryVC = configureCachedLibraryModule()
        configurePlayerView()
        viewControllers = [trackListVC, cachedLibraryVC]
    }
        
    private func configureCachedLibraryModule() -> UIViewController {
        guard let navVC = UIStoryboard(name: "TrackList", bundle: nil).instantiateInitialViewController() as? UINavigationController,
            let view = navVC.viewControllers.first as? TrackListViewController else {
                return UIViewController()
        }
        
        let presenter: TrackListPresenterProtocol = CachedLibraryPresenter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.tabBarDelegate = self
        
        view.tabBarItem.image = UIImage(systemName: "square.and.arrow.down.fill")
        view.tabBarItem.title = "Cached Library"
        
        return navVC
    }
    
    private func configureTrackListModule() -> UIViewController {
        
        guard let navVC = UIStoryboard(name: "TrackList", bundle: nil).instantiateInitialViewController() as? UINavigationController,
            let view = navVC.viewControllers.first as? TrackListViewController else {
                return UIViewController()
        }
        
        let presenter: TrackListPresenterProtocol = TrackListPresenter(token: token)
        let networkService: TrackListNetworkServiceProtocol = NetworkService()
        
        view.presenter = presenter
        presenter.networkService = networkService
        presenter.view = view
        presenter.tabBarDelegate = self
        
        view.tabBarItem.image = UIImage(systemName: "music.note.list")
        view.tabBarItem.title = "Track List"
        
        return navVC
     }
    
    private func configurePlayerView() {
        guard let playerView = playerView else { return }
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.router?.tabBarDelegate = self
        view.insertSubview(playerView, belowSubview: tabBar)

        fullTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -65)
        bottomAnchorConstraint = playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)

        bottomAnchorConstraint.isActive = true
        fullTopAnchorConstraint.isActive = true
        
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}

extension MainViewController: PlayerViewAppearanceDelegate {
    
    func presentFullPlayerScreen(tracksQueue: [Track]?) {
        
        minimizedTopAnchorConstraint.isActive = false
        fullTopAnchorConstraint.isActive = true
        fullTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.isHidden = true
                        self.playerView?.minimizedPlayerView.isHidden = true
                        self.playerView?.fullScreenPlayerStackView.isHidden = false
        },
                       completion: nil)
        guard let trackList = tracksQueue,
            let firstTrack = trackList.first else { return }
        playerView?.interactor?.token = token
        playerView?.interactor?.trackList = trackList
        playerView?.interactor?.setTrack(track: firstTrack)
    }

    func minimizePlayerScreen() {
        fullTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.isHidden = false
                        self.playerView?.minimizedPlayerView.isHidden = false
                        self.playerView?.fullScreenPlayerStackView.isHidden = true
        },
                       completion: nil)
    }
}
