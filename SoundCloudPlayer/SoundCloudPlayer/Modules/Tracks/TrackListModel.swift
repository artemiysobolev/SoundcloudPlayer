//
//	TrackModel.swift
// 	SoundCloudPlayer
//

import Foundation

struct Track: Decodable {
    let id: Int
    let title: String
    let genre: String?
    let duration: Int
    let artworkUrl: String?
}

struct TrackViewData {
    let id: Int
    let title: String
    let genre: String?
    let duration: String
    let artworkUrl: String?
}
