//
//	PlayerRouter.swift
// 	SoundCloudPlayer
//

import Foundation

class PlayerRouter: PlayerDataPassing, PlayerRoutingLogic {
    weak var tabBarDelegate: PlayerViewAppearanceDelegate?
    
    func minimizePlayerScreen() {
        tabBarDelegate?.minimizePlayerScreen()
    }
    
    func presentFullPlayerScreen() {
        tabBarDelegate?.presentFullPlayerScreen(tracksQueue: nil)
    }
}
