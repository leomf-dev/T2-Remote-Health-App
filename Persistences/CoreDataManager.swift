//
//  CoreDataManager.swift
//  T2-Remote-Health-App
//
//  Created by DESIGN on 23/04/26.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MedicalApp") 
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
