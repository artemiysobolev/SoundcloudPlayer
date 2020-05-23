//
//	LoginPresenter.swift
// 	SoundCloudPlayer
//

import UIKit

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
        view?.showAlertController(title: "Login error", message: errorMessage)
    }
    
    func loginAttemptSuccess() {
        view?.showAlertController(title: "Success", message: "You are get a token!")
    }
    
}
