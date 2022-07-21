//
//  ImageRow.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 26/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import SwiftUI
import CachedAsyncImage

struct ImageRow: View {
    private let image: LocalImage
    private let client: RestClient?
    
    init(image: LocalImage, client: RestClient?) {
        self.image = image
        self.client = client
    }
    
    var body: some View {
        HStack {
            networkImage(url: URL(string: image.metaData.thumbnail_url))
                .frame(width: 100, height: 100)

            VStack(alignment: .leading) {
                Text("\(image.metaData.name)").font(.title)
                Text("\(image.metaData.category)")
                Text("\(image.metaData.number)")
            }
            
            Spacer()
        }
    }
}

struct ImageRow_Previews: PreviewProvider {
    static var previews: some View {
        let images = LocalImages(images: loadJSON(fromFile: "sample.JSON"))
        
        return Group {
            ImageRow(image: images.images[0], client: nil)
            ImageRow(image: images.images[1], client: nil)
        }
        .previewLayout(.fixed(width: 400, height: 120))
    }
}
