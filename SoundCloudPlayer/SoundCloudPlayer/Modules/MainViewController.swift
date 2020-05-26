//
//	MainViewController.swift
// 	SoundCloudPlayer
//

import UIKit

class MainViewController: UITabBarController {
    var token: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let trackListVC = configureTrackListModule()
        viewControllers = [trackListVC]
    }
    
    private func configureTrackListModule() -> UIViewController {
        guard let view = UIStoryboard(name: "TrackList", bundle: nil).instantiateInitialViewController() as? TrackListViewController else { return UIViewController() }
        
        let presenter: TrackListPresenterProtocol = TrackListPresenter(token: token)
        let networkService: TrackListNetworkServiceProtocol = NetworkService()
        
        view.presenter = presenter
        presenter.networkService = networkService
        presenter.view = view
        
        return view
     }
}
