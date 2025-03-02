//
//  PasswordDetailView.swift
//  Password Manager
//
//  Created by admin on 28/02/25.
//

import SwiftUI

struct PasswordDetailView: View {
    @ObservedObject var password: PasswordEntity // Use @ObservedObject for real-time updates
    @State private var isPasswordVisible = false
    @State private var isEditing = false  // To show the Edit screen
    @Environment(\.presentationMode) var presentationMode
    var viewModel: PasswordViewModel  // ViewModel to handle deletion
    @Binding var selectedPassword: PasswordEntity?  // Binding to selectedPassword to reflect changes

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Account Details")
                .font(.title2).bold()
                .foregroundColor(.blue)
                .padding(.top, 20)
                .padding(.leading, 25)
                .padding(.bottom, 10)

           
            VStack(alignment: .leading) {
                DetailRow(title: "Account Type", value: password.accountName)
                DetailRow(title: "Username/ Email", value: password.email)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Password")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.leading, 25)

                HStack {
                    let decryptedPassword = EncryptionHelper.decrypt(encryptedText: password.encryptedPassword) ?? "Decryption Failed"
                    Text(isPasswordVisible ? decryptedPassword : "********")
//                    Text(isPasswordVisible ? (EncryptionHelper.decrypt(encryptedText: password.encryptedPassword) ?? "Error") : "********") // Decrypt password
                        .font(.body)
                        .bold()
                    Spacer()
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                            .font(.headline)
                    }
                }
                .padding(.horizontal, 25)
            }
            .padding(.top, 10)

            
            HStack(spacing: 20) {
                Button(action: {
                    isEditing = true  // Show Edit Password Screen
                }) {
                    Text("Edit")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .sheet(isPresented: $isEditing) { // Open EditPasswordView
                    EditPasswordView(passwordEntity: password, viewModel: viewModel, selectedPassword: $selectedPassword)
                }

                Button(action: {
                    viewModel.deletePassword(password) // Deletes from CoreData
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Delete")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 25) // Adjusted padding to align properly
            .padding(.top, 20)

            Spacer()
        }
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .presentationDetents([.fraction(0.6), .large]) // Bottom sheet size
    }
}

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
    }
}
