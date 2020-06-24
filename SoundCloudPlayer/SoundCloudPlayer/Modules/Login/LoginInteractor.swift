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
                presenter?.presentAlert(title: "Empty fields", message: "Enter email and password and try again")
                return
        }
        
        networkService?.sendOAuthRequest(email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                                         password: password.trimmingCharacters(in: .whitespacesAndNewlines),
                                         completionHandler: { [weak self] result  in
                                            
                                            guard let self = self else { return }
                                            DispatchQueue.main.async {
                                                switch result {
                                                case .success(let token):
                                                    self.saveAccessToken(token: token)
                                                    self.presenter?.loginAttemptSuccess(token: token)
                                                case .failure(let error):
                                                    self.presenter?.loginAttemptDidFail(errorMessage: error.rawValue)
                                                }
                                            }
        })
    }
    
    private func saveAccessToken(token: String) {
        let tokenData: Data = token.data(using: .utf8)!
        KeychainService.save(key: KeychainKeys.accessToken, value: tokenData)
    }
}
