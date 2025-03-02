//
//  EditPasswordView.swift
//  Password Manager
//
//  Created by admin on 01/03/25.
//

import SwiftUI

struct EditPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var accountName: String
    @State private var username: String
    @State private var password: String
    var passwordEntity: PasswordEntity
    var viewModel: PasswordViewModel
    @Binding var selectedPassword: PasswordEntity? // Add this Binding to update selectedPassword in HomeView

    init(passwordEntity: PasswordEntity, viewModel: PasswordViewModel, selectedPassword: Binding<PasswordEntity?>) {
        self.passwordEntity = passwordEntity
        self.viewModel = viewModel
        self._selectedPassword = selectedPassword // Initialize the Binding
        _accountName = State(initialValue: passwordEntity.accountName)
        _username = State(initialValue: passwordEntity.email)
        _password = State(initialValue: EncryptionHelper.decrypt(encryptedText: passwordEntity.encryptedPassword) ?? "")
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Edit Account")
                .font(.title2).bold()
                .padding(.top, 10)

            TextField("Account Name", text: $accountName)  // Edit Account Name
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .shadow(radius: 2)

            TextField("Username/ Email", text: $username)  // Edit Email
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .shadow(radius: 2)

            SecureField("Password", text: $password)  // Edit Password
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .shadow(radius: 2)

            Button(action: {
                // Update password
                viewModel.updatePassword(passwordEntity: passwordEntity, account: accountName, email: username, password: password)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    viewModel.fetchPasswords()  // Ensure HomeView refreshes before dismissing
                    selectedPassword = passwordEntity // Update selectedPassword to refresh the detail view
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save Changes")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}
