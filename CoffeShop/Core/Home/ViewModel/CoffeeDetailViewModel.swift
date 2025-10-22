//
//  CoffeeDetailViewModel.swift
//  CoffeShop
//
//  Created by Beto Salcido on 21/10/25.
//

import Foundation

class CoffeeDetailViewModel: ObservableObject {
        
    @Published var coffeeDetail: Coffee?
    
    private let service: HomeService
    private let coffee: Coffee
    private var coffeeDetailCopy: Coffee?

    init(service: HomeService, coffee: Coffee) {
        self.service = service
        self.coffee = coffee
        
        Task {
            await fetchCoffeDetail()
        }
    }
}

// MARK: - Private Methods
private extension CoffeeDetailViewModel {
    
    func fetchCoffeDetail() async {
        do {
            let detail = try await service.fetchCoffeeDetail(coffee.id)
            print(detail)
            self.coffeeDetail = detail
            self.coffeeDetailCopy = detail
            
        } catch {
            print("[DEBUG]: Error fetching coffee detail: \(error)")
        }
    }
}

// MARK: - Public Methods
extension CoffeeDetailViewModel {
    
}
