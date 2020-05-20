//
//	LoginProtocols.swift
// 	SoundCloudPlayer
//

import Foundation

protocol LoginViewProtocol: class {
    var presenter: LoginPresenterProtocol? { get set }
}

protocol LoginPresenterProtocol: class {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    // View -> Presenter
    func signIn(email: String, password: String)
    func signUp()
}

protocol LoginRouterProtocol: class {
    static func createLoginModule()
    //Presenter -> Router
}

protocol LoginInteractorOutputProtocol: class {
    // Presenter -> Interactor
}

protocol LoginInteractorInputProtocol: class {
    var presenter: LoginInteractorOutputProtocol? { get set }
    var networkManager: LoginNetworkManagerInputProtocol? { get set }
    
    // Interactor -> Presenter
}

protocol LoginNetworkManagerInputProtocol: class {
    // Interactor -> Network Manager
}
