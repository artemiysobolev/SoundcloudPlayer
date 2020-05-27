//
//	UIImage+Extension.swift
// 	SoundCloudPlayer
//

import UIKit
import Alamofire

var imageCache = NSCache<NSString, UIImage>()

class NetworkUIImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
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
