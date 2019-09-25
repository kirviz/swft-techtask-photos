//
//  LocalImages.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 25/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import Foundation
import Combine

final class LocalImages: ObservableObject {
    // there are no requirements to keep the UUIDs in the client app, so ignoring them for simplicity
    @Published var images: [ImageModel] = []
    
    init() {
    }
    
    init(images: ImageModels) {
        self.images = images.toArray()
    }
}

extension ImageModels {
    func toArray() -> [ImageModel] {
        return Array(self.images.values).sorted(by: { (left, right) -> Bool in
            return left.index < right.index
        })
    }
}
