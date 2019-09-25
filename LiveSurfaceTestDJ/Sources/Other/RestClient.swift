//
//  RestClient.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 25/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import Foundation
import Combine

class RestClient {
    private let apiKey = "c87aed78-6e6c-41c7-959d-76fbee138452"
    private let baseURL = "https://www.livesurface.com/test"
    
    private var cancellable: AnyCancellable?
    
    public private(set) var localImages = LocalImages()
    
    public func fetch() {
        guard let url = generateURL(with: .imageList(apiKey: apiKey)) else { return }
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ImageModels.self, decoder: JSONDecoder())
            .replaceError(with: ImageModels(images: [:]))
            .map { $0.toArray() }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] images in
                self?.localImages.images = images
            })
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
    
    
    public var properties: (path: String, queryItems: [URLQueryItem]?) {
        switch self {
        case let .imageList(key): return (path: "/api/images.php", queryItems: [URLQueryItem(name: "key", value: key),
//                                                                                URLQueryItem(name: "pro", value: "1")
                                                                                ])
        }
    }
}
