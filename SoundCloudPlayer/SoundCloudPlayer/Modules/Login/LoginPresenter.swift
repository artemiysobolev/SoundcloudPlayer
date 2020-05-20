//
//	LoginPresenter.swift
// 	SoundCloudPlayer
//

import Foundation

class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    
    var interactor: LoginInteractorInputProtocol?
    
    var router: LoginRouterProtocol?
    
    func signIn(email: String, password: String) {
        
    }
    
    func signUp() {
        
    }
}

extension LoginPresenter: LoginInteractorOutputProtocol {
    
}
