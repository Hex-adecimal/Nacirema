//
//  Songs.swift
//  Nacirema
//
//  Created by Luigi Penza on 18/11/23.
//

import Foundation
import SwiftData

@Model class Song {
    var image: String
    var name: String
    var artist: String
    
    init(image: String, name: String, artist: String) {
        self.image = image
        self.name = name
        self.artist = artist
    }
}
