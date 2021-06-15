//
//  DataController.swift
//  bingo-golf
//
//  Created by Austin Zani on 6/14/21.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewController = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let game = Game(context: viewContext)
            game.date = Date()
            game.course = "Course \(i)"
            
            for j in 1...4 {
                let golfer = Golfer(context: viewContext)
                golfer.firstName = "Golfer"
                golfer.lastName = "\(j)"
                game.golfers?.adding(golfer)
            }
            
            for x in 1...9 {
                let hole = Hole(context: viewContext)
                hole.number = Int16(x)
                hole.bingo = game.golfers?.anyObject() as? Golfer
                hole.bango = game.golfers?.anyObject() as? Golfer
                hole.bongo = game.golfers?.anyObject() as? Golfer
                game.holes?.adding(hole)
            }
        }
        
        try viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Game.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Hole.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
        
        let fetchRequest3: NSFetchRequest<NSFetchRequestResult> = Golfer.fetchRequest()
        let batchDeleteRequest3 = NSBatchDeleteRequest(fetchRequest: fetchRequest3)
        _ = try? container.viewContext.execute(batchDeleteRequest3)
    }
}
