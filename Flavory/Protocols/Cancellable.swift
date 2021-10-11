//
//  Cancellable.swift
//  Flavory
//
//  Created by Ivan Stoilov on 8.10.21.
//

import Foundation

protocol Cancellable {
    
    func cancel()
    
}

extension URLSessionTask: Cancellable {
    
}
