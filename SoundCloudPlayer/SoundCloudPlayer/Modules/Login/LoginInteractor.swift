//
//	LoginInteractor.swift
// 	SoundCloudPlayer
//

import Foundation

class LoginInteractor: LoginInteractorInputProtocol {
    weak var presenter: LoginInteractorOutputProtocol?
    var networkManager: LoginNetworkManagerInputProtocol?
}
