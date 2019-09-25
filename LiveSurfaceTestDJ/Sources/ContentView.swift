//
//  ContentView.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 25/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var dates = [Date]()
    
    @EnvironmentObject private var images: LocalImages

    var body: some View {
        NavigationView {
            MasterView(dates: $dates).environmentObject(images)
                .navigationBarTitle(Text("So many beautiful images"))
                .navigationBarItems(
                    leading: Button(
                        action: {
                            // TODO: refresh
                        }
                    ) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                )
            DetailView()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MasterView: View {
    @Binding var dates: [Date]
    
    @EnvironmentObject private var images: LocalImages

    var body: some View {
        List {
            ForEach(images.images, id: \.index) { image in
                NavigationLink(
                    destination: DetailView(selectedImage: image)
                ) {
                    Text("\(image.image)")
                }
            }
        }
    }
}

struct DetailView: View {
    var selectedImage: ImageModel?

    var body: some View {
        Group {
            if selectedImage != nil {
                Text("\(selectedImage!.image)")
            } else {
                Text("Swipe right to browse images")
            }
        }.navigationBarTitle(Text("Best image ever!"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let images = LocalImages(images: loadJSON(fromFile: "sample.JSON"))
        return ContentView().environmentObject(images)
    }
}
