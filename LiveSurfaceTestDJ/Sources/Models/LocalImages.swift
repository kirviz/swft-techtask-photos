//
//  LocalImages.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 25/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import Foundation
import Combine
import UIKit

struct LocalImage: Identifiable {
    var id: Int { metaData.index }
    
    public let metaData: ImageModel
    public var downloadedImage: UIImage?
}

final class LocalImages: ObservableObject {
    @Published var images: [LocalImage] = []
    
    init() {
    }
    
    init(images: ImageModels) {
        self.images = images.toLocalImages()
    }
}

extension ImageModels {
    func toLocalImages() -> [LocalImage] {
        return self.images.values.sorted(by: { (left, right) -> Bool in
            return left.index < right.index
        }).map { LocalImage(metaData: $0, downloadedImage: nil) }
    }
}
