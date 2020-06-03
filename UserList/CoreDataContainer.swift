//
//  CoreDataContainer.swift
//  UserList
//
//  Created by abra on 3/06/20.
//  Copyright © 2020 LogosEros. All rights reserved.
//

import Foundation
import CoreData

class CoreDataContainer {
    private let model: String
    
    init(model: String) {
        self.model = model
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.model)
        container.loadPersistentStores{ (description, error) in
            if let error = error as NSError? {
                print("Unresolved Error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    func saveContext () {
        guard managedContext.hasChanges else {return}
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved Error \(error), \(error.userInfo)")
        }
    }
}
