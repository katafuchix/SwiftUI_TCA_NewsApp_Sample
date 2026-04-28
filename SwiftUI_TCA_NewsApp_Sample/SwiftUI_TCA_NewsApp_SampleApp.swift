//
//  SwiftUI_TCA_NewsApp_SampleApp.swift
//  SwiftUI_TCA_NewsApp_Sample
//
//  Created by cano on 2026/04/29.
//

import SwiftUI
import ComposableArchitecture

@main
struct SwiftUI_TCA_NewsApp_SampleApp: App {
    var body: some Scene {
        WindowGroup {
            ArticleView(
                store: Store(initialState: ArticleFeature.State()) {
                    ArticleFeature()
                }
            )
        }
    }
}
