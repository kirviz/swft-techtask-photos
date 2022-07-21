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
    private let baseURL = "http://127.0.0.1:8080/livesurface/"
    private let thumbnailSize = 200
    
    private var disposables = Set<AnyCancellable>()
    
    public private(set) var localImages = LocalImages()
    
    enum FailureReason : Error {
        case sessionFailed(error: URLError)
        case decodingFailed(error: Swift.DecodingError)
        case other(Error)
    }
    
    public func fetchImageList() {
        self.localImages.loading = true

        guard let url = generateURL(with: .imageList(thumbnailSize: thumbnailSize)) else { return }
        
        let failable: AnyPublisher<ImageModels, FailureReason>
        
        failable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ImageModels.self, decoder: JSONDecoder())
            .mapError({ error in
              switch error {
              case let decodingError as Swift.DecodingError:
                  return .decodingFailed(error: decodingError)
              case let urlError as URLError:
                  return .sessionFailed(error: urlError)
              default:
                  return .other(error)
              }
            })
            .eraseToAnyPublisher()
        
        let recovered = failable
            .catch { (error) -> Just<ImageModels> in
                // send to an error logger in a real project
                print(error)
                return Just(ImageModels(images: [:]))
            }
        
        recovered
            .map { $0.toLocalImages() }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] images in
                self?.localImages.images = images
                self?.localImages.loading = false
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
    case imageList(thumbnailSize: Int)
    
    public var properties: (path: String, queryItems: [URLQueryItem]?) {
        switch self {
        case let .imageList(thumbnailSize):
            return (path: "list/",
                    queryItems: [URLQueryItem(name: "thumbnail_size", value: "\(thumbnailSize)")])
        }
    }
}
