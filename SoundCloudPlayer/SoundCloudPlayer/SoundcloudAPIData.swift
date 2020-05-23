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

struct SoundcloudAPIData {
    static let oauthUrlString = "https://api.soundcloud.com/oauth2/token"
    static let meUrlString = "https://api.soundcloud.com/me"
    static let clientID = "08cb4bc9efc7ebeb5945abe37ae11b39"
    static let clientSecret = "43d7b47398b1e57bf05a6f8ce0cc8a49"
    static let redirectURI = "https://example.com/callback"
    static let scope = "*"
    static let accessTokenKeychainName = "SoundcloudToken"
}
