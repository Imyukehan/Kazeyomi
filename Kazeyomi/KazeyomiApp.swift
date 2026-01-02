//
//  KazeyomiApp.swift
//  Kazeyomi
//
//  Created by 于可汗 on 12/15/25.
//

import SwiftUI

@main
struct KazeyomiApp: App {
    @State private var serverSettings = ServerSettingsStore()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(serverSettings)
        }
    }
}
