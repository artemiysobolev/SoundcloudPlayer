//
//	LoginPresenter.swift
// 	SoundCloudPlayer
//

import Foundation

class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    var router: LoginRouterProtocol?
    
    func sendLoginData(email: String?, password: String?) {
        interactor?.loginAttempt(email: email, password: password)
    }
}

extension LoginPresenter: LoginInteractorOutputProtocol {
    func loginAttemptDidFail(errorMessage: String) {
        presentAlert(title: "Login error", message: errorMessage)
    }
    
    func loginAttemptSuccess(token: String) {
        router?.presentMainScreen(from: view, token: token)
    }
    
    func presentAlert(title: String, message: String) {
        view?.showAlertController(title: title, message: message)
    }
    
}
