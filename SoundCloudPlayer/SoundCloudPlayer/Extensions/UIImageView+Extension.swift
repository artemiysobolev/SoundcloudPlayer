//
//	UIImage+Extension.swift
// 	SoundCloudPlayer
//

import UIKit
import Alamofire

var imageCache = NSCache<NSString, UIImage>()

class CustomUIImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        image = nil
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if let url = URL(string: urlString, relativeTo: documents), url.isFileURL {
            loadImageFromDevice(with: url.path)
        } else {
            loadImageFromNetwork(with: urlString)
        }
        return
    }
    
    private func loadImageFromDevice(with path: String) {
        if let data = FileManager.default.contents(atPath: path) {
            self.image = UIImage(data: data)
        } else {
            self.image = #imageLiteral(resourceName: "emptyArtwork")
        }
        return
    }
    
    private func loadImageFromNetwork(with urlString: String) {
        imageUrlString = urlString
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        AF.request(urlString).validate(statusCode: [200]).responseData { response in
            switch response.result {
            case .success(let value):
                DispatchQueue.main.async {
                    guard let imageToCache = UIImage(data: value) else { return }
                    self.image = imageToCache
                    
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}
