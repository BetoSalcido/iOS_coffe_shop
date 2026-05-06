//
//  CoffeeDetailViewModel.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 21/10/25.
//

import Foundation
import Observation

@Observable @MainActor
final class CoffeeDetailViewModel {

    var coffeeDetail: Coffee?
    var selectedSizeId: String?
    
    private let service: any CoffeeCatalogProviding
    private let coffee: Coffee
    private var coffeeDetailCopy: Coffee?

    init(service: any CoffeeCatalogProviding, coffee: Coffee) {
        self.service = service
        self.coffee = coffee
        
        Task {
            await fetchCoffeeDetail()
        }
    }
}

// MARK: - Private Methods
private extension CoffeeDetailViewModel {
    
    func fetchCoffeeDetail() async {
        do {
            let detail = try await service.fetchCoffeeDetail(coffee.id)
            print(detail)
            self.coffeeDetail = detail
            self.coffeeDetailCopy = detail
            
            // Seleccionar el primer tamaño activo por defecto, o el primero si ninguno está activo
            if let firstActiveSize = detail.sizes.first(where: { $0.isActive }) {
                selectedSizeId = firstActiveSize.id
            } else if let firstSize = detail.sizes.first {
                selectedSizeId = firstSize.id
                updateSelectedSize(firstSize.id)
            }
            
        } catch {
            print("[DEBUG]: Error fetching coffee detail: \(error)")
        }
    }
    
    func updateSelectedSize(_ sizeId: String) {
        guard let detail = coffeeDetail else { return }
        
        // Actualizar el array de sizes con el nuevo estado
        let updatedSizes = detail.sizes.map { size in
            CoffeeSize(
                id: size.id,
                name: size.name,
                isActive: size.id == sizeId
            )
        }
        
        // Crear una nueva instancia de Coffee con los sizes actualizados
        coffeeDetail = Coffee(
            id: detail.id,
            name: detail.name,
            description: detail.description,
            longDescription: detail.longDescription,
            rating: detail.rating,
            price: detail.price,
            imageURL: detail.imageURL,
            sizes: updatedSizes
        )
    }
}

// MARK: - Public Methods
extension CoffeeDetailViewModel {
    
    func handleCoffeeSizeSelectionWith(_ size: CoffeeSize) {
        selectedSizeId = size.id
        updateSelectedSize(size.id)
    }
}
