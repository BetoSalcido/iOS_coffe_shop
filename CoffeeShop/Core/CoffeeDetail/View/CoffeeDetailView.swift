//
//  CoffeeDetailView.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 21/10/25.
//

import SwiftUI

struct CoffeeDetailView: View {
    
    @StateObject private var viewModel: CoffeeDetailViewModel

    init(coffee: Coffee, catalogService: any CoffeeCatalogProviding) {
        _viewModel = StateObject(wrappedValue: CoffeeDetailViewModel(service: catalogService, coffee: coffee))
    }
    
    var body: some View {
        NavigationStack {
            if let detail = viewModel.coffeeDetail {
                ScrollView {
                    CoffeeDetailHeaderView(coffee: detail)
                    CoffeeDetailBodyView(coffee: detail) {
                        viewModel.handleCoffeeSizeSelectionWith($0)
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
    CoffeeDetailView(coffee: DeveloperPreview().coffees[0], catalogService: CoffeeCatalogService())
}
