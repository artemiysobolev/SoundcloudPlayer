//
//	TrackModel.swift
// 	SoundCloudPlayer
//

import Foundation

enum TrackCacheStatus {
    case notCached
    case cached
    case inCachedLibrary
}

struct Track: Decodable, Equatable {
    let id: Int
    let title: String
    let genre: String?
    let duration: Int
    let artworkUrl: String?
    let streamUrl: String
    
    var durationSeconds: Int {
        return duration / 1000
    }
    var largeArtworkUrl: String? {
        return artworkUrl?.replacingOccurrences(of: "large", with: "crop")
    }
}

struct TrackViewData {
    let title: String
    let genre: String?
    let duration: String
    let artworkUrl: String?
    let cacheStatus: TrackCacheStatus
}
