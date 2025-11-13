//
//  CoffeeDetailView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 21/10/25.
//

import SwiftUI

struct CoffeeDetailView: View {
    
    @StateObject private var viewModel: CoffeeDetailViewModel

    init(coffee: Coffee, service: HomeService = HomeService()) {
        _viewModel = StateObject(wrappedValue: CoffeeDetailViewModel(service: service, coffee: coffee))
    }
    
    var body: some View {
        NavigationStack {
            if let detail = viewModel.coffeeDetail {
                ScrollView {
                    CoffeeDetailHeaderView(coffee: detail)
                    CoffeeDetailBodyView(coffee: detail) {
                        viewModel.handleCoffeSizeSelecionWith($0)
                    }
                }
                .background(Color.init(hex: "#F9F9F9"))
                
                CoffeeDetailFooterView(coffee: detail) {
                    
                }
            } else {
                
            }
        }
    }
}

#Preview {
    CoffeeDetailView(coffee: DeveloperPreview().coffees[0])
}
