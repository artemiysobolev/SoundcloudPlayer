//
//	SceneDelegate.swift
// 	SoundCloudPlayer
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let token = String(data: KeychainService.load(key: KeychainKeys.accessToken) ?? Data(), encoding: .utf8)

        let presentMainVC = {
            let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MainViewController
            mainVC.token = token
            self.window?.rootViewController = mainVC
            self.window?.makeKeyAndVisible()
        }

        guard InternetConnectionService.isConnectedToNetwork() else {
            presentMainVC()
            return
        }
        
        NetworkService.tokenValidationRequest(token: token) { [weak self] isValid in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isValid {
                    presentMainVC()
                } else {
                    let loginModule = LoginRouter.createLoginModule()
                    self.window?.rootViewController = loginModule
                    self.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
}
