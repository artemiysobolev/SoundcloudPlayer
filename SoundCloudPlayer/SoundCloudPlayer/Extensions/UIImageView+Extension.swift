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
        if let url = URL(string: urlString, relativeTo: AppDirectories.documents.rawValue), url.isFileURL {
            loadImageFromDevice(with: url)
        } else {
            loadImageFromNetwork(with: urlString)
        }
        return
    }
    
    private func loadImageFromDevice(with url: URL) {
        if let data = FileSystemService.readFile(from: url) {
            image = UIImage(data: data)
        } else {
            image = #imageLiteral(resourceName: "emptyArtwork")
        }
        return
    }
    
    private func loadImageFromNetwork(with urlString: String) {
        imageUrlString = urlString
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            image = imageFromCache
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
