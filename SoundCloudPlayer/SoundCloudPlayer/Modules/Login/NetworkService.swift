//
//	NetworkService.swift
// 	SoundCloudPlayer
//

import Foundation
import Alamofire

class NetworkService: LoginNetworkServiceInputProtocol {
    
    func sendOAuthRequest(email: String,
                          password: String,
                          completionHandler: @escaping (_ token: String?, _ error: String?) -> Void) {
        
        var httpBody: [String: Any] = [:]
        httpBody["client_id"] = SoundcloudAPIData.clientID
        httpBody["client_secret"] = SoundcloudAPIData.clientSecret
        httpBody["grant_type"] = GrantType.password
        httpBody["redirect_uri"] = SoundcloudAPIData.redirectURI
        httpBody["scope"] = SoundcloudAPIData.scope
        httpBody["username"] = email
        httpBody["password"] = password
        
        AF.request(SoundcloudAPIData.oauthUrlString, method: .post, parameters: httpBody)
            .validate(statusCode: [200])
            .responseJSON { response in
                
                switch response.result {
                case .success(let value):
                    guard let jsonResponse = value as? [String: Any],
                        let token = jsonResponse["access_token"] as? String else {
                            completionHandler(nil, "Incorrect response from server")
                        return
                    }
                    completionHandler(token, nil)
                case .failure(let error):
                    if error.responseCode == 401 {
                        completionHandler(nil, "Incorrect username or password")
                    } else {
                        completionHandler(nil, "Some undefined error")
                    }
                }
        }
    }
}
