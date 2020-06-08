//
//	TrackModel.swift
// 	SoundCloudPlayer
//

import Foundation

struct Track: Decodable, Equatable {
    let id: Int
    let title: String
    let genre: String?
    let duration: Int
    let artworkUrl: String?
    let streamUrl: String?
}

struct TrackViewData {
    let title: String
    let genre: String?
    let duration: String
    let artworkUrl: String?
}
