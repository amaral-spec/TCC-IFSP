//
//  TCC_IFSPApp.swift
//  TCC-IFSP
//
//  Created by Gabriel Amaral on 10/02/26.
//

import SwiftUI

@main
struct SeuApp: App {
    @State private var emotionVM = EmotionClassifierViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(emotionVM)
        }
    }
}
