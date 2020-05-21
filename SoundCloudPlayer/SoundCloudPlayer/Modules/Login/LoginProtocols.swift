//
//	LoginProtocols.swift
// 	SoundCloudPlayer
//

import UIKit

protocol LoginViewProtocol: class {
    var presenter: LoginPresenterProtocol? { get set }
    
    //Presenter -> View
    func showSafariAuth(with url: URL)
}

protocol LoginPresenterProtocol: class {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    // View -> Presenter
    func login()
}

protocol LoginRouterProtocol: class {
    static func createLoginModule() -> UIViewController
    
    //Presenter -> Router
}

protocol LoginInteractorOutputProtocol: class {
    // Interactor -> Presenter
    func didRecieveLoginUrl(url: URL)
}

protocol LoginInteractorInputProtocol: class {
    var presenter: LoginInteractorOutputProtocol? { get set }
    var networkService: LoginNetworkServiceInputProtocol? { get set }
    
    // Presenter -> Interactor
    func createLoginUrl()
}

protocol LoginNetworkServiceInputProtocol: class {
    // Interactor -> Network Manager
    func createOauthUrl() -> URL
}
