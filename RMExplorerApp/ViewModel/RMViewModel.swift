//
//  RMViewModel.swift
//  RMExplorerApp
//
//  Created by Rafael Cabrera on 8/22/26.
//


//
//  RMViewModel.swift
//  RMExplorer
//
//  Created by Rafael Cabrera on 8/22/26.
//

import Foundation

@MainActor
class RMViewModel: ObservableObject {

    @Published var characters: [Character] = []
    @Published var locations: [Location] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    let rmService: RMService = RMService()
    let role: Role

    init(role: Role) {
        self.role = role
    }

    // Loads characters. Both roles are allowed to call this.
    func loadCharacters() async {
        isLoading = true
        errorMessage = ""

        do {
            characters = try await rmService.fetchCharacters()
        } catch let error as RMService.NetworkError {
            errorMessage = message(for: error)
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // Loads locations. Only the Admin role is allowed to call this.
    func loadLocations() async {
        isLoading = true
        errorMessage = ""

        do {
            locations = try await rmService.fetchLocations(role: role)
        } catch let error as RMService.NetworkError {
            errorMessage = message(for: error)
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func message(for error: RMService.NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "The URL provided was invalid."
        case .invalidResponse:
            return "The server response was invalid."
        case .invalidStatusCode:
            return "The server returned an unexpected status code."
        case .decodingError:
            return "Failed to decode the data."
        case .unauthorized:
            return "You are not authorized to access this endpoint."
        }
    }
}