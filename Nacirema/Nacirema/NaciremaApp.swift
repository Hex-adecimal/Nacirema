//
//  NaciremaApp.swift
//  Nacirema
//
//  Created by Luigi Penza on 14/11/23.
//

import SwiftUI

//MARK: https://hotpot.ai/attribution for images

//TODO: Animation for audio
//TODO: Animation snake like
//TODO: Accessibility
//TODO: Colors
//TODO: 

@main
struct NaciremaApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Song.self)
    }
}
