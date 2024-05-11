//
//  ContentView.swift
//  Finny
//
//  Created by Dennis Dang on 5/5/24.
//

import AuthenticationServices
import Foundation
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        TabView {
            NavigationSplitView {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text(
                                "Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))"
                            )
                        } label: {
                            Text(
                                item.timestamp,
                                format: Date.FormatStyle(date: .numeric, time: .standard)
                            )
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            } detail: {
                Text("Select an item")
            }.tabItem {
                Label("Home", systemImage: "person")
            }

            NavigationSplitView {
                VStack {
                    Spacer()  // Pushes all content to the middle

                    SignInWithAppleButton(
                        .signIn,
                        onRequest: configureRequest,
                        onCompletion: handleAuthorization
                    ).signInWithAppleButtonStyle(.black)
                        .frame(width: 280, height: 44)

                    Spacer()  // Pushes all content to the middle
                }.frame(maxWidth: .infinity, maxHeight: .infinity)

            } detail: {
                Text("Select an item")
            }.tabItem {
                Label("Sign In", systemImage: "person.fill")
            }
        }
    }

    private func configureRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    private func handleAuthorization(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential
                as? ASAuthorizationAppleIDCredential,
                let appleIDToken = appleIDCredential.identityToken,
                let idTokenString = String(data: appleIDToken, encoding: .utf8)
            {
                Task {
                    do {
                        let response = try await sendJWTToServer(jwt: idTokenString)
                        print("Server responded with: \(response)")
                    } catch {
                        print("Failed to send JWT or parse response: \(error)")
                    }
                }
            }
        case .failure(let error):
            print("Authorization failed: \(error)")
        }
    }

    func sendJWTToServer(jwt: String) async throws -> String {
        guard let url = URL(string: "https://finny-backend.fly.dev/api/users/register")
        else {
            throw URLError(.badURL)
        }
        
        debugPrint(jwt)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        let body: [String: Any] = ["type": "apple"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }

        if let responseString = String(data: data, encoding: .utf8) {
            return responseString
        } else {
            throw URLError(.cannotParseResponse)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
