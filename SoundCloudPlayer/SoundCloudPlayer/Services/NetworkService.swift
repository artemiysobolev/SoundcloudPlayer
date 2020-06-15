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
    
    func downloadTrackToDevice(audioUrlString: String?,
                               imageUrlString: String?,
                               token: String,
                               id: Int,
                               completion: @escaping(_ audioPath: String?, _ imagePath: String?) -> Void) {
        let downloadGroup = DispatchGroup()
        var audioPath: String?
        var imagePath: String?
        if let audioUrlString = audioUrlString {
            downloadGroup.enter()
            downloadFile(from: audioUrlString,
                         to: .audio,
                         filename: String(id),
                         headers: [HTTPHeader(name: "Authorization", value: "OAuth \(token)")]) { resultPath in
                            audioPath = resultPath
                            downloadGroup.leave()
            }
        }
        if let imageUrlString = imageUrlString {
            downloadGroup.enter()
            downloadFile(from: imageUrlString, to: .images, filename: nil, headers: nil) { resultPath in
                imagePath = resultPath
                downloadGroup.leave()
            }
        }
        downloadGroup.notify(queue: .main) {
            guard audioPath != nil else {
                if let imagePath = imagePath { FileSystemService.removeFile(from: imagePath) }
                return
            }
            completion(audioPath, imagePath)
        }
    }
    
    private func downloadFile(from urlString: String,
                              to directory: Folders,
                              filename: String?,
                              headers: HTTPHeaders?,
                              completionHandler: @escaping(String?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completionHandler(nil)
            return
        }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.headers = headers ?? HTTPHeaders()
        var relativePath = directory.rawValue + "/" + (filename ?? url.lastPathComponent)
        if directory == .audio {
            relativePath.append(".mp3")
        }
        
        let destination: DownloadRequest.Destination = { _, _ in
            return (URL(fileURLWithPath: relativePath, relativeTo: AppDirectories.documents.rawValue),
                    [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(urlRequest, to: destination).downloadProgress { progress in
            print(progress.fractionCompleted)
        }.response { response in
            print(response)
            switch response.result {
            case .success:
                completionHandler(relativePath)
            case .failure:
                completionHandler(nil)
            }
        }
    }
    
}
