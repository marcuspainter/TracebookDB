//
//  TracebookDBApp.swift
//  TracebookDB
//
//  Created by Marcus Painter on 07/07/2025.
//

import SwiftUI
import SwiftData

@main
struct TracebookDBApp: App {
    @State var tracebookService  = TracebookService()
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            MainView()
        }
        .environment(self.tracebookService)
        
    }
}
