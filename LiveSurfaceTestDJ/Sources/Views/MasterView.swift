//
//  MasterView.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 26/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    @EnvironmentObject private var images: LocalImages
    
    private let client: RestClient?
    
    init(client: RestClient?) {
        self.client = client
    }
    
    func imageOrPlaceholder(_ image: LocalImage) -> Image {
        if let downloadedImage = image.downloadedImage {
            return Image(uiImage: downloadedImage)
        } else {
            return Image("placeholder")
        }
    }

    var body: some View {
        List {
            ForEach(images.images) { (image: LocalImage) in
                NavigationLink(
                    destination: DetailView(selectedImage: image)
                ) {
                    HStack {
                        self.imageOrPlaceholder(image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)

                        Text("\(image.metaData.image)")
                    }.onAppear {
                        if image.downloadedImage == nil {
                            self.client?.downloadImage(localImage: image)
                        }
                    }
                }
            }
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        let images = LocalImages(images: loadJSON(fromFile: "sample.JSON"))
        return MasterView(client: nil).environmentObject(images)
    }
}
