//
//  imageCacher.swift
//  CgExercise
//
//  Created by Test User 1 on 11/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit

typealias ImageCacheLoaderCompletionHandler = ((UIImage,Bool) -> ())

class ImageLoader {
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<NSString, UIImage>!
    
    static let sharedInstance = ImageLoader()
    
    init() {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
    }
    
    func isKeyAvailable(imagePath: String) -> Bool {
        if let _ = self.cache.object(forKey: imagePath as NSString) {
            return true
        }
        return false
    }
    
    func removeAll() -> Void {
        cache.removeAllObjects()
    }
    func obtainImageWithPath(imagePath: String?, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
        let placeholder = #imageLiteral(resourceName: "sample")
        if imagePath == nil{
            DispatchQueue.main.async {
                completionHandler(placeholder, false)
                return
            }
        }
        else{
            if let image = self.cache.object(forKey: imagePath! as NSString) {
                DispatchQueue.main.async {
                    completionHandler(image, true)
                }
            } else {
                /* You need placeholder image in your assets,
                 if you want to display a placeholder to user */
                
                let url: URL! = URL(string: imagePath!)
                if url == nil { return }
                task = session.downloadTask(with: url, completionHandler: {[weak self] (location, response, error) in
                    if let data = try? Data(contentsOf: url) {
                        let finalImage: UIImage! = UIImage(data: data)
                        if let image = finalImage {
                            self?.cache.setObject(image, forKey: imagePath! as NSString)
                            DispatchQueue.main.async {
                                completionHandler(image, false)
                            }
                        }
                    }
                    })
                task.resume()
            }
        }
    }
}

