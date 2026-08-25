//  Character.swift
//  RMExplorerApp
//
//  Created by Rafael Cabrera on 8/22/26.
//

import Foundation

struct CharacterResponse: Codable {
    let results: [Character]
}

struct Character: Codable, Identifiable {

    let id: Int
    let name: String
    let status: String
    let species: String
    let image: String
}
