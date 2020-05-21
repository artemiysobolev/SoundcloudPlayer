//
//	NetworkService.swift
// 	SoundCloudPlayer
//

import Foundation

class NetworkService: LoginNetworkServiceInputProtocol {
    
    func createOauthUrl() -> URL {
        var urlComponents = URLComponents(string: SoundcloudAPIData.connectUrlString)
        urlComponents?.queryItems = createQueryItems()
        return (urlComponents?.url)!
    }
    
    private func createQueryItems() -> [URLQueryItem] {
        let parameters = [
            "client_id": SoundcloudAPIData.clientID,
            "client_secret": SoundcloudAPIData.clientSecret,
            "response_type": "token",
            "redirect_uri": SoundcloudAPIData.redirectURI,
            "scope": "non-expiring",
            "display": "popup" ]
        
        var queryItems = [URLQueryItem]()
        for (name, value) in parameters {
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        return queryItems
    }
}
