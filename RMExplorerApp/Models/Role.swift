//  Role.swift
//  RMExplorerApp
//
//  Created by Rafael Cabrera on 8/22/26.
//

import Foundation

enum Role: String, CaseIterable, Identifiable, Hashable {
    case admin = "Admin"
    case user = "User"

    var id: String { rawValue }
}
