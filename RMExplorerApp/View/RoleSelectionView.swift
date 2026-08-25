//  RoleSelectionView.swift
//  RMExplorer
//
//  Created by Rafael Cabrera on 8/22/26.
//

import SwiftUI

struct RoleSelectionView: View {

    @State private var selectedRole: Role? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Select Your Role")
                    .font(.largeTitle)
                    .bold()

                Text("Admin can call every endpoint.\nUser can only call the Characters endpoint.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                ForEach(Role.allCases) { role in
                    Button(role.rawValue) {
                        selectedRole = role
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(width: 160)
                }
            }
            .padding()
            .navigationDestination(item: $selectedRole) { role in
                RMView(role: role)
            }
        }
    }
}

#Preview {
    RoleSelectionView()
}
