//
//  bingo_golfApp.swift
//  bingo-golf
//
//  Created by Austin Zani on 6/14/21.
//

import SwiftUI

@main
struct BingoGolfApp: App {
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
