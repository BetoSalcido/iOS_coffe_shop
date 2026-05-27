//
//  EditProfileView.swift
//  CoffeeShop
//

import SwiftUI

struct EditProfileView: View {
    @State private var viewModel = EditProfileViewModel()

    var body: some View {
        Text("Edit Profile")
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .blackNavigationBarStyle()
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}
