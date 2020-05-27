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
        
        guard let navVC = UIStoryboard(name: "TrackList", bundle: nil).instantiateInitialViewController() as? UINavigationController,
            let view = navVC.viewControllers.first as? TrackListViewController else {
                return UIViewController()
        }
        
        let presenter: TrackListPresenterProtocol = TrackListPresenter(token: token)
        let networkService: TrackListNetworkServiceProtocol = NetworkService()
        
        view.presenter = presenter
        presenter.networkService = networkService
        presenter.view = view
        
        return navVC
     }
}
