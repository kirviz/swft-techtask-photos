//
//  ContentView.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 25/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var images: LocalImages
    
    private let client: RestClient?
    
    init(client: RestClient?) {
        self.client = client
    }

    var body: some View {
        NavigationView {
            MasterView(client: client)
                .navigationBarTitle(Text("So many beautiful images"))
                .navigationBarItems(
                    leading: Button(
                        action: {
                            self.client?.localImages.images = []
                            self.client?.fetchImageList()
                        }
                    ) {
                        Image(systemName: "arrow.counterclockwise")
                    }
                )
            DetailView()
        }.navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                self.client?.fetchImageList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let images = LocalImages(images: loadJSON(fromFile: "sample.JSON"))
        return ContentView(client: nil).environmentObject(images)
    }
}
