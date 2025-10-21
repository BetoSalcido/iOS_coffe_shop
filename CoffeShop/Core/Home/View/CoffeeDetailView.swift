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
        _viewModel = StateObject(wrappedValue: CoffeeDetailViewModel(service: service, coffee: coffee)
        )
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CoffeeDetailView(coffee: DeveloperPreview().coffees[0])
}
