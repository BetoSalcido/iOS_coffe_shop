//
//  SettingsHeaderView.swift
//  CoffeeShop
//

import SwiftUI

struct SettingsHeaderView: View {

    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        VStack {
            Image(viewModel.isUserPro ? "UserProIcon" : "UserIcon")
                .resizable()
                .frame(width: 96, height: 96)
            
            Text(viewModel.displayName)
                .font(.headline)
                .foregroundStyle(.black)


            if viewModel.isUserPro {
                HStack {
                    Image("ProIcon")
                        .resizable()
                        .frame(width: 11, height: 11)
                    
                    Text("Gold Member")
                        .font(.caption)
                        .foregroundStyle(Color.Tag.primary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.Tag.primaryBackgtound)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 16)
        .background(Color.Background.item)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview("Pro") {
    let vm = SettingsViewModel(service: AppServiceProvider.live)
    SettingsHeaderView(viewModel: vm)
        .padding()
        .onAppear { vm.isUserPro = true }
}

#Preview("Free") {
    SettingsHeaderView(viewModel: SettingsViewModel(service: AppServiceProvider.live))
        .padding()
}
