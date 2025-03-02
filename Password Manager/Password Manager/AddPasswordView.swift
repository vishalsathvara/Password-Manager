//
//  AddPasswordView.swift
//  Password Manager
//
//  Created by admin on 28/02/25.

import SwiftUI

struct AddPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var accountName = ""
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false  // Error Handling

    var viewModel: PasswordViewModel  //ViewModel to save data

    var body: some View {
        VStack(spacing: 10) {
            Capsule()
                .frame(width: 50, height: 5)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.top, 10)

            ScrollView {
                VStack(spacing: 15) {
                    // Account Name TextField with Border
                    TextField("Account Name", text: $accountName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
                        .padding(.horizontal, 10)
                        .textInputAutocapitalization(.none)
                        .disableAutocorrection(true)

                    // Username TextField with Border
                    TextField("Username/ Email", text: $username)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
                        .padding(.horizontal, 10)
                        .textInputAutocapitalization(.none)
                        .disableAutocorrection(true)

                    // Password SecureField with Border
                    SecureField("Password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
                        .padding(.horizontal, 10)

                    // Password Strength Indicator
                    PasswordStrengthView(password: $password)

                    // Password Generator Button
                    PasswordGeneratorView(password: $password)

                    if showError {
                        Text("All fields are required!")
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 5)
                    }

                    Button(action: {
                        if accountName.isEmpty || username.isEmpty || password.isEmpty {
                            showError = true
                        } else {
                            viewModel.addPassword(account: accountName, email: username, password: password)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Add New Account")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
                .padding()
            }
        }
        .background(Color(UIColor.systemGray6))
        .ignoresSafeArea(.keyboard)
        .scrollDismissesKeyboard(.interactively)
    }
}



struct PasswordStrengthView: View {
    @Binding var password: String
    
    var strength: String? {
        guard !password.isEmpty else { return nil } //Show nothing when empty
        
        let length = password.count
        let hasNumbers = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSymbols = password.rangeOfCharacter(from: .symbols) != nil || password.rangeOfCharacter(from: .punctuationCharacters) != nil
        
        if length >= 8 && hasNumbers && hasSymbols {
            return "Strong"
        } else if length >= 6 && (hasNumbers || hasSymbols) {
            return "Medium"
        } else {
            return "Weak"
        }
    }
    
    var strengthColor: Color {
        switch strength {
        case "Strong": return .green
        case "Medium": return .orange
        default: return .red
        }
    }
    
    var body: some View {
        if let strength = strength { 
            HStack {
                Text("Strength: ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(strength)
                    .bold()
                    .foregroundColor(strengthColor)
            }
            .padding(.top, 5)
        }
    }
}


struct PasswordGeneratorView: View {
    @Binding var password: String
    
    func generatePassword() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
        return String((0..<12).map { _ in characters.randomElement()! })
    }
    
    var body: some View {
        Button(action: {
            password = generatePassword()
        }) {
            Text("Generate Strong Password")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(40)
        }
        .padding(.horizontal, 20)
    }
}

