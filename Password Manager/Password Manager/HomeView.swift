//  HomeView.swift
//  Password Manager
//
//  Created by admin on 28/02/25.

import SwiftUI
struct HomeView: View {
    @StateObject private var viewModel = PasswordViewModel()
    @State private var isShowingAddPassword = false
    @State private var selectedPassword: PasswordEntity? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6)
                    .edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Password Manager")
                            .font(.title2)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                        Spacer()
                    }
                    Divider()

                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.passwords, id: \PasswordEntity.objectID) { password in
                                Button(action: {
                                    selectedPassword = password
                                }) {
                                    PasswordRowView(password: password)
                                }
                            }
                        }
                        .padding(.top, 30)
                    }
                }

                VStack() {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingAddPassword.toggle()
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 65, height: 65)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                        }
                        .padding()
                        .sheet(isPresented: $isShowingAddPassword, onDismiss: {
                            viewModel.fetchPasswords()
                        }) {
                            AddPasswordView(viewModel: viewModel)
                                .presentationDetents([.fraction(0.5)])
                        }
                    }
                }

                if isShowingAddPassword || selectedPassword != nil {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .animation(.easeInOut, value: isShowingAddPassword || selectedPassword != nil)
                }
            }
        }
        
        .sheet(item: $selectedPassword, onDismiss: {
            viewModel.fetchPasswords()
        }) { password in
            PasswordDetailView(password: password, viewModel: viewModel, selectedPassword: $selectedPassword)
        }
        .onAppear {
            viewModel.fetchPasswords()
        }
    }
}



struct PasswordRowView: View {
    @ObservedObject var password: PasswordEntity

    var body: some View {
        HStack {
            Text(password.accountName) // CoreData Account Name
                .font(.headline)
                .foregroundColor(.black)
            Text(" ********")
                .font(.title)
                .foregroundColor(.gray)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 70) 
        .background(RoundedRectangle(cornerRadius: 40).fill(Color.white))
        .padding(.horizontal, 20)
    }
}
