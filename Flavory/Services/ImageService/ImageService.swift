//
//  ImageManager.swift
//  Flavory
//
//  Created by Ivan Stoilov on 7.10.21.
//

import UIKit

class ImageService{
    
    static let shared = ImageService()
    
    private let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    enum NetworkError: Error {
        case badConnection
    }
    
    func getImage( rawUrl: String, id: Int, completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable?{
        let url = URL(string: rawUrl)
        if isFileExists(name: String(id)) {
            completionHandler(.success(UIImage(contentsOfFile: cachesDirectory.appendingPathComponent("\(String(id)).jpg").path) ?? UIImage())) 
        }
        else {
            let task = downlaodImage(url: url!) { result in
                switch result{
                case .success(let image):
                    self.cacheImageInData(image: image, name: String(id))
                    completionHandler(.success(image))
                case .failure(let error):
                    print("qj mi kuraaaaaa")
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
                completionHandler(.success(image))
            }
            if error != nil {
                print("qj mi kuraaaaaa")
                completionHandler(.failure(.badConnection))
            }
        })
        downloadTask.resume()
        return downloadTask
    }
    
    private func cacheImageInData (image: UIImage, name: String) {
        
        let path = cachesDirectory.appendingPathComponent("\(name).jpg")
        
        let data = image.jpegData(compressionQuality: 1)
        do {
            try data?.write(to: path)
        }
        catch {
            print("error in image asving")
        }
    }
    
    private func isFileExists(name: String) -> Bool {
        return FileManager.default.fileExists(atPath: cachesDirectory.appendingPathComponent("\(String(name)).jpg").path)
    }
}
