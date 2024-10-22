//
//	LoginProtocols.swift
// 	SoundCloudPlayer
//

import UIKit

protocol LoginViewProtocol: class {
    var presenter: LoginPresenterProtocol? { get set }
    
    //Presenter -> View
    func showAlertController(title: String, message: String)
}

protocol LoginPresenterProtocol: class {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    // View -> Presenter
    func sendLoginData(email: String?, password: String?)
}

protocol LoginRouterProtocol: class {
    static func createLoginModule() -> UIViewController
    
    //Presenter -> Router
    func presentMainScreen(from view: LoginViewProtocol?, token: String)
}

protocol LoginInteractorInputProtocol: class {
    var presenter: LoginInteractorOutputProtocol? { get set }
    var networkService: LoginNetworkServiceInputProtocol? { get set }
    
    // Presenter -> Interactor
    func loginAttempt(email: String?, password: String?)
}

protocol LoginInteractorOutputProtocol: class {
    // Interactor -> Presenter
    func presentAlert(title: String, message: String)
    func loginAttemptDidFail(errorMessage: String)
    func loginAttemptSuccess(token: String)
}

protocol LoginNetworkServiceInputProtocol: class {
    // Interactor -> Network Service
//    func sendOAuthRequest(email: String, password: String, completionHandler: @escaping(String?, String?) -> Void)
    func sendOAuthRequest(email: String, password: String, completionHandler: @escaping(Result<String, NetworkError>) -> Void)
}
