//
//  CoreDataManager.swift
//  Password Manager
//
//  Created by admin on 01/03/25.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "PasswordManager", managedObjectModel: Self.createModel()) // Manually Register Model
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    static func createModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "PasswordEntity"
        entity.managedObjectClassName = NSStringFromClass(PasswordEntity.self)

        let accountName = NSAttributeDescription()
        accountName.name = "accountName"
        accountName.attributeType = .stringAttributeType
        accountName.isOptional = false

        let email = NSAttributeDescription()
        email.name = "email"
        email.attributeType = .stringAttributeType
        email.isOptional = false

        let encryptedPassword = NSAttributeDescription()
        encryptedPassword.name = "encryptedPassword"
        encryptedPassword.attributeType = .stringAttributeType
        encryptedPassword.isOptional = false

        entity.properties = [accountName, email, encryptedPassword]
        model.entities = [entity]

        return model
    }
}
