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
    let downloadUrl: String
}
