//
//	LoginInteractor.swift
// 	SoundCloudPlayer
//

import Foundation

class LoginInteractor: LoginInteractorInputProtocol {
    weak var presenter: LoginInteractorOutputProtocol?
    var networkService: LoginNetworkServiceInputProtocol?
    
    func loginAttempt(email: String?, password: String?) {
        guard let email = email, !email.isEmptyOrWhitespace(),
            let password = password, !password.isEmptyOrWhitespace() else {
                print("error!")
                return
        }
        
        networkService?.sendOAuthRequest(email: email, password: password,
                                         completionHandler: { [weak self] token, error  in
                                            
                                            guard let self = self else { return }
                                            guard token != nil,
                                                error == nil else {
                                                    self.presenter?.loginAttemptDidFail(errorMessage: error!)
                                                    return
                                            }
                                            self.saveAccessToken()
                                            self.presenter?.loginAttemptSuccess()
                                            
        })
    }
    
    private func saveAccessToken() {
        // Save token to keychain
    }
}
