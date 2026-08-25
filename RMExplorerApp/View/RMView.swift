//  RMView.swift
//  RMExplorer
//
//  Created by Rafael Cabrera on 8/22/26.
//

import SwiftUI

struct RMView: View {

    @StateObject private var viewModel: RMViewModel
    @State private var isCharLoaded: Bool = false
    @State private var isLocLoaded: Bool = false
    let role: Role

    init(role: Role) {
        self.role = role
        _viewModel = StateObject(wrappedValue: RMViewModel(role: role))
    }

    var body: some View {
        VStack {
            Text("Logged in as \(role.rawValue)")
                .font(.headline)
                .padding(.top)

            HStack {
                Button(isCharLoaded ? "Hide Characters" : "Get Characters") {
                    if isCharLoaded {
                        viewModel.clearCharacters()
                        isCharLoaded = false
                    } else {
                        Task {
                            await viewModel.loadCharacters()
                            isCharLoaded = true
                        }
                    }
                }
                .buttonStyle(.bordered)

                // Only the Admin role sees the second endpoint's button at all.
                if role == .admin {
                    Button(isLocLoaded ? "Hide Locations" : "Get Locations") {
                        if isLocLoaded {
                            viewModel.clearLocations()
                            isLocLoaded = false
                        } else {
                            Task {
                                await viewModel.loadLocations()
                                isLocLoaded = true
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()

            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }

            List {
                if !viewModel.characters.isEmpty {
                    Section("Characters") {
                        ForEach(viewModel.characters) { character in
                            HStack {
                                AsyncImage(url: URL(string: character.image)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(character.name)
                                        .font(.headline)
                                    Text("\(character.species) • \(character.status)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }

                if !viewModel.locations.isEmpty {
                    Section("Locations") {
                        ForEach(viewModel.locations) { location in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(location.name)
                                    .font(.headline)
                                Text("\(location.type) • \(location.dimension)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("RM Explorer")
    }
}

#Preview {
    RMView(role: .admin)
}
