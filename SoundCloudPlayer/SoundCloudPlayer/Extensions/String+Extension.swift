//
//	String+Extension.swift
// 	SoundCloudPlayer
//

import Foundation

extension String {
    func isEmptyOrWhitespace() -> Bool {
        if isEmpty {
            return true
        }
        return (trimmingCharacters(in: .whitespaces) == "")
    }
}
