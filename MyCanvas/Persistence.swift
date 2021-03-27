//
//  Persistence.swift
//  MyCanvas
//
//  Created by Student on 26.03.21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "MyCanvas")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let Item1 = Drawing(context: viewContext)
        Item1.id = UUID()
        Item1.name = "My Drawing"
        Item1.timestamp = Date()
        Item1.data = Data()
        
        let Item2 = Drawing(context: viewContext)
        Item2.id = UUID()
        Item2.name = "Other Drawing"
        Item2.timestamp = Date()
        Item2.data = Data()
        
        let Item3 = Drawing(context: viewContext)
        Item3.id = UUID()
        Item3.timestamp = Date()
        Item3.data = Data()
        
        do {
            try viewContext.save()
        } catch {
            // Replace this
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
