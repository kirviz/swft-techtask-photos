//
//  DetailView.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 26/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var selectedImage: LocalImage?

    var body: some View {
        Group {
            if selectedImage != nil {
                Text("\(selectedImage!.metaData.image)")
            } else {
                Text("Swipe right to browse images")
            }
        }.navigationBarTitle(Text("Best image ever!"))
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
