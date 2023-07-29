//
//  FeedService.swift
//  macapp
//
//  Created by nick on 13/07/2023.
//

import CoreData
import Foundation

/// Controller to manage the app data
struct DataStore {
    /// Persistent container
    let container: NSPersistentContainer
    
    /// Static instance
    static let shared: DataStore = DataStore()
    
    /// Preview instance of the controller
    static var preview: DataStore = {
        let store = DataStore(inMemory: true)
        
        // add sample data for preview
        var feeds: [(String, String)] = []
        feeds.append(("https://ai.googleblog.com/atom.xml", "Google AI"))
        feeds.append(("https://simonwillison.net/atom/everything/", "Willison blog"))
        for f in feeds {
            let feed = Feed(context: store.container.viewContext)
            feed.id = UUID()
            feed.link = URL(string: f.0)
            feed.title = f.1
        }
        
        return store
    }()
    

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores {storeDescription, error in
            if let error = error {
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error)")
                }
            }
        }
    }
    
    /// Saves the context
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
                fatalError("DataStore save error \(error)")
            }
        }
    }
}