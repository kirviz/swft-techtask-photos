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

    var body: some View {
        if images.loading {
            ProgressView()
        } else {
            List {
                ForEach(images.images) { (image: LocalImage) in
                    NavigationLink(
                        destination: DetailView(image: image)
                    ) {
                        ImageRow(image: image, client: self.client)
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
