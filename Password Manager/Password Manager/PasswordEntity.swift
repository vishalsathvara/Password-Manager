//
//  PasswordEntity.swift
//  Password Manager
//
//  Created by admin on 01/03/25.
//

import Foundation
import CoreData

@objc(PasswordEntity)
class PasswordEntity: NSManagedObject, Identifiable {
    @NSManaged var accountName: String
    @NSManaged var email: String
    @NSManaged var encryptedPassword: String
}


extension PasswordEntity {
    static func create(in context: NSManagedObjectContext, accountName: String, email: String, password: String) -> PasswordEntity {
        let entity = PasswordEntity(context: context)
        entity.accountName = accountName
        entity.email = email
        entity.encryptedPassword = password
        return entity
    }
}
