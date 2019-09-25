//
//  RestClient.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 25/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class RestClient {
    private let apiKey = "c87aed78-6e6c-41c7-959d-76fbee138452"
    private let baseURL = "https://www.livesurface.com/test"
    
    private var disposables = Set<AnyCancellable>()
    
    public private(set) var localImages = LocalImages()
    
    public func fetchImageList() {
        guard let url = generateURL(with: .imageList(apiKey: apiKey)) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ImageModels.self, decoder: JSONDecoder())
            .replaceError(with: ImageModels(images: [:]))
            .map { $0.toLocalImages() }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] images in
                self?.localImages.images = images
            }).store(in: &disposables)
    }
    
    public func downloadImage(localImage: LocalImage) {
        guard let url = generateURL(with: .downloadImage(fileName: localImage.metaData.image)) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                let newImage = LocalImage(metaData: localImage.metaData, downloadedImage: image)
                // this is scary... would be better to get back to dictionary (but need to copy the UUID into the LocalImage)
                self?.localImages.images[localImage.metaData.index] = newImage
            }).store(in: &disposables)
    }
    
    private func generateURL(with endpoint: Endpoint) -> URL? {
        let (path, queryItems) = endpoint.properties
        
        let urlString = "\(baseURL)\(path)"
        
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}

public enum Endpoint {
    case imageList(apiKey: String)
    case downloadImage(fileName: String)
    
    
    public var properties: (path: String, queryItems: [URLQueryItem]?) {
        switch self {
        case let .imageList(key):
            return (path: "/api/images.php",
                    queryItems: [URLQueryItem(name: "key", value: key),
//                                 URLQueryItem(name: "pro", value: "1")
                                ])
        case let .downloadImage(fileName):
            return (path: "/images/\(fileName)", queryItems: nil)
        }
    }
}
