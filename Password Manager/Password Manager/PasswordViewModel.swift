import SwiftUI
import CoreData

class PasswordViewModel: ObservableObject {
    @Published var passwords: [PasswordEntity] = [] // @Published to trigger view updates
    private let context = CoreDataManager.shared.context
    
    init() {
        fetchPasswords()
    }

    // Fetch passwords and notify the UI
    func fetchPasswords() {
        DispatchQueue.global(qos: .background).async {
            let request: NSFetchRequest<PasswordEntity> = NSFetchRequest(entityName: "PasswordEntity")
            do {
                let fetchedPasswords = try self.context.fetch(request)
                DispatchQueue.main.async {
                    self.passwords = fetchedPasswords // Updating the published property
                }
            } catch {
                print("Error fetching passwords: \(error)")
            }
        }
    }

    // Save new password
    func addPassword(account: String, email: String, password: String) {
        let encryptedPassword = EncryptionHelper.encrypt(text: password) ?? ""
        let newPassword = PasswordEntity(context: context)
        newPassword.accountName = account
        newPassword.email = email
        newPassword.encryptedPassword = encryptedPassword
        
        saveContext()
    }
    
    // Update password details
    func updatePassword(passwordEntity: PasswordEntity, account: String, email: String, password: String) {
        let encryptedPassword = EncryptionHelper.encrypt(text: password) ?? ""
        
        passwordEntity.accountName = account
        passwordEntity.email = email
        passwordEntity.encryptedPassword = encryptedPassword
        
        saveContext()
    }

    // Delete password
    func deletePassword(_ password: PasswordEntity) {
        context.delete(password)
        saveContext()
    }

    // Save context after any changes
    private func saveContext() {
        do {
            try context.save()
            fetchPasswords() // Reload the passwords after saving
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
