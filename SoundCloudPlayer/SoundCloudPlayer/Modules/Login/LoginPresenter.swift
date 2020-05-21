//
//	LoginPresenter.swift
// 	SoundCloudPlayer
//

import UIKit

class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    var router: LoginRouterProtocol?
    
    func login() {
        interactor?.createLoginUrl()
    }
}

extension LoginPresenter: LoginInteractorOutputProtocol {
    func didRecieveLoginUrl(url: URL) {
        view?.showSafariAuth(with: url)
    }
}
