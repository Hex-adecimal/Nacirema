//
//  ViewController.swift
//  Nacirema
//
//  Created by Luigi Penza on 14/11/23.
//

import Foundation
import Observation
import ShazamKit

struct MatchResult: Identifiable, Equatable {
    let id = UUID()
    let match: SHMatch?
}

@MainActor @Observable final class ViewController {
    var isMatching = false
    var currentMatchResult: MatchResult?
    
    var currentMediaItem: SHMatchedMediaItem? {
        currentMatchResult?.match?.mediaItems.first
    }
    
    private let session: SHManagedSession
    
    init() {
        let parentCatalog = SHCustomCatalog()
        do {
            let assetFileName = "Currents"
            let assetFileExtension = "shazamcatalog"

            if let assetURL = Bundle.main.url(forResource: assetFileName, withExtension: assetFileExtension) {
                print("URL of the asset:")
                print(assetURL)
                try parentCatalog.add(from: assetURL)
                session = SHManagedSession(catalog: parentCatalog)
                print("SESSION OK!")
            } else {
                print("nope")
                session = SHManagedSession()
            }
        } catch {
            print("An error occurred: \(error)")
            session = SHManagedSession()
        }
    }
    
    func match() async {
        isMatching = true
        
        for await result in session.results {
            switch result {
            case .match(let match):
                Task { @MainActor in
                    self.currentMatchResult = MatchResult(match: match)
                }
            case .noMatch(_):
                print("No match")
                endSession()
            case .error(let error, _):
                print("Error \(error.localizedDescription)")
                endSession()
            }
            stopRecording()
        }
    }
    
    func stopRecording() {
        session.cancel()
    }
    
    func endSession() {
        // Reset result of any previous match.
        isMatching = false
        currentMatchResult = MatchResult(match: nil)
    }
}
