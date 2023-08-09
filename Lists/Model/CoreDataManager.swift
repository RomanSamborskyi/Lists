//
//  CoreDataManager.swift
//  Lists
//
//  Created by Roman Samborskyi on 05.08.2023.
//

import Foundation
import CoreData


class CoreDataManager {
    
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    let containerName: String = "ListsContainer"
    let listEntityName: String = "ListEntity"
    let itemEntityNAme: String = "ItemEnteity"
    
    init () {
       container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR OF LOAD CORE DATA: \(error)")
            } else {
                print("SUCCESS")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("ERROR OF SAVING DATA: \(error)")
        }
    }
}
