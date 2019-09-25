//
//  DetailView.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 26/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var image: LocalImage?
    
    // so weird to use exclamation mark...
    var data: ImageModel { image!.metaData }

    var body: some View {
        Group {
            if image != nil {
                VStack {
                    ImageRow.imageOrPlaceholder(image).resizable().aspectRatio(contentMode: .fit)
                    
                    Group {
                        Group {
                        Text(" ")
                        HStack { Text("Image information").font(.title); Spacer() }
                        HStack { Text("Index:"); Spacer(); Text("\(data.index)") }
                        HStack { Text("Name:"); Spacer(); Text("\(data.name)") }
                        HStack { Text("Number:"); Spacer(); Text("\(data.number)") }
                        HStack { Text("Image:"); Spacer(); Text("\(data.image)") }
                        HStack { Text("Category:"); Spacer(); Text("\(data.category)") }
                        HStack { Text("Version:"); Spacer(); Text("\(data.version)") }
                        }
                        
                        Group {
                        Text(" ")
                        HStack { Text("Size information").font(.title); Spacer() }
                        HStack { Text("Description:"); Spacer(); Text("\(data.tags.sizeDescription)") }
                        HStack { Text("Scale:"); Spacer(); Text("\(data.tags.sizeScale)") }
                        HStack { Text("Width:"); Spacer(); Text("\(data.tags.sizeWidth)") }
                        HStack { Text("Height:"); Spacer(); Text("\(data.tags.sizeHeight)") }
                        HStack { Text("Units:"); Spacer(); Text("\(data.tags.sizeUnits)") }
                        }
                    }.frame(maxWidth: 300)
                    
                    Spacer()
                }.navigationBarTitle(Text("\(data.name)"))
            } else {
                Text("Swipe right to browse images")
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let images = LocalImages(images: loadJSON(fromFile: "sample.JSON"))
        
        return Group {
            DetailView(image: images.images[0])
//            DetailView(image: images.images[1])
        }
//        .previewLayout(.fixed(width: 260, height: 600))
    }
}
