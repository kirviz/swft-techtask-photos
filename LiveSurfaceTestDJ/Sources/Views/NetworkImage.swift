//
//  NetworkImage.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 21/07/2022.
//  Copyright © 2022 Darius Jankauskas. All rights reserved.
//

import SwiftUI
import CachedAsyncImage

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 256*1000*1000, diskCapacity: 1*1000*1000*1000)
}

func networkImage(url: URL?) -> some View {
    CachedAsyncImage(url: url, urlCache: .imageCache) { phase in
        if let image = phase.image {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if phase.error != nil {
            Image("placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
        }
    }
}
