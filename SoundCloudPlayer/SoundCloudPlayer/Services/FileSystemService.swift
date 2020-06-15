//
//	FileSystemService.swift
// 	SoundCloudPlayer
//

import Foundation

enum Folders: String {
    case images
    case audio
}

enum AppDirectories {
    case documents
    case inbox
    case library
    case temp
}

extension AppDirectories: RawRepresentable {
    typealias RawValue = URL
    
    var rawValue: URL {
        switch self {
        case .documents:
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        case .inbox:
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Inbox")
        case .library:
            return FileManager.default.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: .userDomainMask).first!
        case .temp:
            return FileManager.default.temporaryDirectory
        }
    }
    
    init?(rawValue: URL) { nil }
}

class FileSystemService {
    static func removeFile(from relativePath: String) {
        guard let url = URL(string: relativePath, relativeTo: AppDirectories.documents.rawValue) else { return }
        do {
            try FileManager.default.removeItem(atPath: url.path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func readFile(from url: URL) -> Data? {
        return FileManager.default.contents(atPath: url.path)
    }
}
