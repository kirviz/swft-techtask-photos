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
    
    init(images: ImageModels) {
        self.images = Array(images.images.values).sorted(by: { (left, right) -> Bool in
            return left.index < right.index
        })
    }
}
