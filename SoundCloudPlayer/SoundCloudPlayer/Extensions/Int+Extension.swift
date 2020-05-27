//
//	Int+Extension.swift
// 	SoundCloudPlayer
//

import Foundation

extension Int {
    func convertMillisecondsDurationToString() -> String {
        
        let seconds = Double(self) / 1000
        
        let(h, m, s) = ( Int(seconds / 3600),
                        Int((seconds / 60).truncatingRemainder(dividingBy: 60)),
                        Int(seconds.truncatingRemainder(dividingBy: 60)))
        
        let hString = h < 10 ? "0\(h)" : "\(h)"
        let mString = m < 10 ? "0\(m)" : "\(m)"
        let sString = s < 10 ? "0\(s)" : "\(s)"
        
        if h > 0 {
            return "\(hString):\(mString):\(sString)"
        }
        return "\(mString):\(sString)"
    }
}
