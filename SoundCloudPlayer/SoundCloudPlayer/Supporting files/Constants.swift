//
//	SoundcloudAPIData.swift
// 	SoundCloudPlayer
//

import Foundation

enum GrantType: String {
    case password
    case authCode = "authorization_code"
    case refreshToken = "refresh_token"
    case clientCredentials = "client_credentials"
}

enum SoundcloudAPIData {
    static let clientID = "08cb4bc9efc7ebeb5945abe37ae11b39"
    static let clientSecret = "43d7b47398b1e57bf05a6f8ce0cc8a49"
    static let scope = "*"
}

enum SoundcloudAPIUrls {
    static let globalUrl = "https://api.soundcloud.com"
    static let oAuth = globalUrl + "/oauth2/token"
    static let tracks = globalUrl + "/me/tracks"
    static let tracksSearch = globalUrl + "/tracks?limit=50&q="
    static let me = globalUrl + "/me"
}

enum KeychainKeys {
    static let accessToken = "SoundcloudToken"
}

enum NetworkError: String, Error {
    case undefinedError = "Some undefined error"
    case wrongAuthData = "Incorrect username or password"
    case badResponse = "Incorrect response from server"
}
