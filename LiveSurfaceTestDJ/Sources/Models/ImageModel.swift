//
//  ImageModel.swift
//  LiveSurfaceTestDJ
//
//  Created by Darius Jankauskas on 25/09/2019.
//  Copyright © 2019 Darius Jankauskas. All rights reserved.
//

import Foundation

struct ImageModels: Codable {
    let images: [String:ImageModel]
}

// SwiftUI has type Image so better not risk it
struct ImageModel: Codable {
    let index: Int
    let name: String
    let number: String
    let image: String
    let category: String
    let version: String
}

struct Tags: Codable {
    // skipping some fields for simplicity sake (kept all those which had changing values in debug feed)
    let sizeDescription: String
    let sizeScale: String
    let sizeWidth: String
    let sizeHeight: String
    let sizeUnits: String
    
    enum CodingKeys: String, CodingKey {
        case sizeDescription = "sizedescription"
        case sizeScale = "sizescale"
        case sizeWidth = "sizewidth"
        case sizeHeight = "sizeheight"
        case sizeUnits = "sizeunits"
    }
}
