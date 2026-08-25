//  Location.swift
//  RMExplorer
//
//  Created by Rafael Cabrera on 8/22/26.
//

import Foundation

struct LocationResponse: Codable {
    let results: [Location]
}

struct Location: Codable, Identifiable {

    let id: Int
    let name: String
    let type: String
    let dimension: String
}
