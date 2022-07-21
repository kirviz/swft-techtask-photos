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
    private let baseURL = "http://127.0.0.1:8080/"
    private let imagesURL = "https://storage.googleapis.com/"
    
    private var disposables = Set<AnyCancellable>()
    
    public private(set) var localImages = LocalImages()
    
    enum FailureReason : Error {
        case sessionFailed(error: URLError)
        case decodingFailed(error: Swift.DecodingError)
        case other(Error)
    }
    
    public func fetchImageList() {
        guard let url = generateURL(with: .imageList(apiKey: apiKey)) else { return }
        
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
                // duplicating the image model with actual image data added
                let newImage = LocalImage(metaData: localImage.metaData, downloadedImage: image)
                // overwriting the image
                self?.localImages.images[localImage.metaData.index] = newImage
            }).store(in: &disposables)
    }
    
    private func generateURL(with endpoint: Endpoint) -> URL? {
        let (path, queryItems) = endpoint.properties
        
        // this may look ugly but is
        let url: String
        switch endpoint {
        case .downloadImage:
            url = imagesURL
        default:
            url = baseURL
        }
        
        let urlString = "\(url)\(path)"
        
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
            return (path: "livesurface/",
                    queryItems: [URLQueryItem(name: "key", value: key),
                                 URLQueryItem(name: "pro", value: "1")
                                ])
        case let .downloadImage(fileName):
            return (path: "krimages/random-smaller/\(fileName)", queryItems: nil)
        }
    }
}
