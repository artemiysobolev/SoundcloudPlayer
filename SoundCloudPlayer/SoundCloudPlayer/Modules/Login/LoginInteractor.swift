//
//	LoginInteractor.swift
// 	SoundCloudPlayer
//

import Foundation

class LoginInteractor: LoginInteractorInputProtocol {    
    weak var presenter: LoginInteractorOutputProtocol?
    var networkService: LoginNetworkServiceInputProtocol?
    
    func createLoginUrl() {
        guard let url = networkService?.createOauthUrl() else { return }
        presenter?.didRecieveLoginUrl(url: url)
    }
}
