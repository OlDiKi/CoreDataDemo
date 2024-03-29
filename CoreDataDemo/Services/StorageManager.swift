//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Дмитрий Олейнер on 26.01.2022.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    // MARK: - Core Data stack

lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreDataDemo")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {

            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()
   
    lazy private var context = persistentContainer.viewContext
    
// MARK: - Core Data Saving support

func saveContext () {
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

//MARK: - Private Methods
    func fetchData(completion: ([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try persistentContainer.viewContext.fetch(fetchRequest)
            completion(taskList)
        } catch let error {
            print("Failed to fetch data", error)
        }
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        
        let task = Task(context: context)
        task.name = taskName
        completion(task)
        saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    
    func delete(_ task: Task) {
        context.delete(task)
        saveContext()
    }
    
}
