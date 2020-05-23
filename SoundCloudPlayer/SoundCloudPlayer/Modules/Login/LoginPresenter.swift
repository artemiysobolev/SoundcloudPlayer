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
        presentAlert(title: "Login error", message: errorMessage)
    }
    
    func loginAttemptSuccess() {
        router?.presentMainScreen(from: view)
    }
    
    func presentAlert(title: String, message: String) {
        view?.showAlertController(title: title, message: message)
    }
    
}
