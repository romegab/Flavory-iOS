//
//  ImageManager.swift
//  Flavory
//
//  Created by Ivan Stoilov on 7.10.21.
//

import UIKit

class ImageManager{
    
    private var dataTask: URLSessionDataTask?
    private let queue = DispatchQueue.global()
    
    func getImage( url: String, completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let url = URL(string: url)
        
        downlaodImage(url: url!) { result in
            switch result{
            case .success(let image):
                DispatchQueue.main.async{
                    completionHandler(.success(image))
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler(.failure(.badConnection))
                }
            }
        }
    }
    
    func downlaodImage(url: URL, completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void){
        let session = URLSession.shared
        session.downloadTask(with: url, completionHandler: { url, response, error in
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completionHandler(.success(image))
                }
            }
            completionHandler(.failure(.badConnection))
        })
    }
}
