//  RMService.swift
//  RMExplorer
//
//  Created by Rafael Cabrera on 8/22/26.
//

import Foundation

class RMService {

    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case invalidStatusCode
        case decodingError
        case unauthorized
    }

    // Endpoint 1: available to Admin AND User
    func fetchCharacters() async throws -> [Character] {

        guard let url: URL = URL(string: "https://rickandmortyapi.com/api/character") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw NetworkError.invalidStatusCode
        }

        do {
            let decoded = try JSONDecoder().decode(CharacterResponse.self, from: data)
            return decoded.results
        } catch {
            throw NetworkError.decodingError
        }
    }

    // Endpoint 2: available to Admin ONLY
    func fetchLocations(role: Role) async throws -> [Location] {

        // Enforced here, not just in the UI, so the wrong role never gets data back.
        guard role == .admin else {
            throw NetworkError.unauthorized
        }

        guard let url: URL = URL(string: "https://rickandmortyapi.com/api/location") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw NetworkError.invalidStatusCode
        }

        do {
            let decoded = try JSONDecoder().decode(LocationResponse.self, from: data)
            return decoded.results
        } catch {
            throw NetworkError.decodingError
        }
    }
}
