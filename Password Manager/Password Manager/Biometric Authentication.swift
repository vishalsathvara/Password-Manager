//
//  Biometric Authentication.swift
//  Password Manager
//
//  Created by admin on 01/03/25.
//

import SwiftUI
import LocalAuthentication

struct BiometricAuthView: View {
    @State private var isAuthenticated = false
    @State private var showAuthError = false
    
    var body: some View {
        VStack {
            if isAuthenticated {
                HomeView() // Navigate to Home Screen after authentication
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Unlock Password Manager")
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    
                    if showAuthError {
                        Text("Authentication Failed. Try Again.")
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    Button(action: {
                        authenticateUser()
                    }) {
                        Text("Use Face ID / Touch ID")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .onAppear {
            authenticateUser()
        }
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock your passwords") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        self.showAuthError = true
                    }
                }
            }
        } else {
            self.showAuthError = true
        }
    }
}
