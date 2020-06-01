//
//	NetworkService.swift
// 	SoundCloudPlayer
//

import Foundation
import Alamofire

class NetworkService: LoginNetworkServiceInputProtocol, TrackListNetworkServiceProtocol {
    
    static func tokenValidationRequest(token: String?, completionHandler: @escaping(Bool) -> Void) {
        guard let token = token else { return }
        let header = HTTPHeader(name: "Authorization", value: "OAuth \(token)")
        
        AF.request("\(SoundcloudAPIData.globalUrl)/me", method: .get, headers: [header])
            .validate(statusCode: [200])
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    completionHandler(true)
                case .failure:
                    completionHandler(false)
                }
        }
    }
    
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
        
        AF.request("\(SoundcloudAPIData.globalUrl)/oauth2/token", method: .post, parameters: httpBody)
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
    
    func getUserTrackList(token: String, complectionHandler: @escaping (Result<[Track], Error>) -> Void) {
        let header = HTTPHeader(name: "Authorization", value: "OAuth \(token)")
        let urlString = "\(SoundcloudAPIData.globalUrl)/me/tracks"
        
        AF.request(urlString, headers: [header]).validate(statusCode: [200]).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let trackList = try decoder.decode([Track].self, from: data)
                    complectionHandler(.success(trackList))
                } catch {
                    complectionHandler(.failure(error))
                }
            case .failure(let error):
                complectionHandler(.failure(error))
            }
        }
    }
    
    func tracksSearchRequest(token: String, searchBody: String, completionHandler: @escaping(Result<[Track], Error>) -> Void) {
        let header = HTTPHeader(name: "Authorization", value: "OAuth \(token)")
        guard let encodedBody = searchBody.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlString = "\(SoundcloudAPIData.globalUrl)/tracks?limit=50&q=" + encodedBody
        
        AF.request(urlString, headers: [header]).validate(statusCode: [200]).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let filteredTrackList = try decoder.decode([Track].self, from: data)
                    completionHandler(.success(filteredTrackList))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
