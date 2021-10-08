//
//  ImageManager.swift
//  Flavory
//
//  Created by Ivan Stoilov on 7.10.21.
//

import UIKit

class ImageService{
    
    static let shared = ImageService()
    
    private let cache = Cache<String, UIImage>()
    
    enum NetworkError: Error {
        case badConnection
    }
    
    func getImage( rawUrl: String, completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable?{
        
        let url = URL(string: rawUrl)
         if let cached = cache[rawUrl] {
             completionHandler(.success(cached))
             print("image loaded from cache \(rawUrl)")
         }
         else {
             let task = downlaodImage(url: url!) { result in
                 switch result{
                 case .success(let image):
                     self.cache.insert(image, forKey: rawUrl)
                     completionHandler(.success(image))
                 case .failure(let error):
                     print("fire from get image")
                     print(error.localizedDescription)
                     completionHandler(.failure(.badConnection))
                 }
             }
             return task
         }
        return nil
    }
    
    private func downlaodImage(url: URL, completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable{
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url, completionHandler: { url, response, error in
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completionHandler(.success(image))
                }
            }
            if error != nil {
                print("fire from download image")
                completionHandler(.failure(.badConnection))
            }
        })
        downloadTask.resume()
        return downloadTask
    }
}
