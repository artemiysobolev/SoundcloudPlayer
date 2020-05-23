//
//	LoginRouter.swift
// 	SoundCloudPlayer
//

import UIKit
import SafariServices

class LoginRouter: LoginRouterProtocol {
    static func createLoginModule() -> UIViewController {
        guard let view = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            as? LoginView else { return  UIViewController() }
        
        let presenter: LoginPresenterProtocol & LoginInteractorOutputProtocol = LoginPresenter()
        let interactor: LoginInteractorInputProtocol = LoginInteractor()
        let networkService: LoginNetworkServiceInputProtocol = NetworkService()
        let router: LoginRouterProtocol = LoginRouter()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        interactor.networkService = networkService
        interactor.presenter = presenter
        
        return view
    }
    
    func presentMainScreen(from view: LoginViewProtocol?) {
        guard let sourceView = view as? UIViewController,
            let mainScreenView = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else {
                return
        }
        sourceView.modalPresentationStyle = .fullScreen
        sourceView.present(mainScreenView, animated: true, completion: nil)
    }
}
