//
//	PlayerInteractor.swift
// 	SoundCloudPlayer
//

import Foundation

class PlayerInteractor: PlayerDataStore, PlayerBusinessLogic {
    
    var presenter: PlayerPresentationLogic?
    var trackList: [Track]!
    var token: String!
    
}
