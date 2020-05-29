//
//	PlayerProtocols.swift
// 	SoundCloudPlayer
//

import Foundation

protocol PlayerDispayLogic: class {
    
}

protocol PlayerBusinessLogic {
    
}

protocol PlayerDataStore {
    var trackList: [Track]! { get set }
    var token: String! { get set }
}

protocol PlayerPresentationLogic {
    
}

protocol PlayerRoutingLogic {
    
}

protocol PlayerDataPassing {
    
}
