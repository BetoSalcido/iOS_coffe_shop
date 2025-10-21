//
//  CoffeeDetailViewModel.swift
//  CoffeShop
//
//  Created by Beto Salcido on 21/10/25.
//

import Foundation

class CoffeeDetailViewModel: ObservableObject {
        
    private let service: HomeService
    private let coffee: Coffee

    init(service: HomeService, coffee: Coffee) {
        self.service = service
        self.coffee = coffee
        print(coffee)

    }
}

// MARK: - Private Methods
private extension HomeViewModel {
    
}

// MARK: - Public Methods
extension HomeViewModel {
    
}
