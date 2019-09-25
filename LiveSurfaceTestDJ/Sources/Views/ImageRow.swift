//
//  ImageRow.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 26/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import SwiftUI

struct ImageRow: View {
    private let image: LocalImage
    private let client: RestClient?
    
    init(image: LocalImage, client: RestClient?) {
        self.image = image
        self.client = client
    }
    
    static func imageOrPlaceholder(_ image: LocalImage?) -> Image {
        if let downloadedImage = image?.downloadedImage {
            return Image(uiImage: downloadedImage)
        } else {
            return Image("placeholder")
        }
    }
    
    var body: some View {
        HStack {
            ImageRow.imageOrPlaceholder(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)

            Text("\(image.metaData.image)")
            
            Spacer()
        }.onAppear {
            if self.image.downloadedImage == nil {
                self.client?.downloadImage(localImage: self.image)
            }
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
