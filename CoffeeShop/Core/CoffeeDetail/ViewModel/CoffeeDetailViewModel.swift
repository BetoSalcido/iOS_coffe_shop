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

    private(set) var coffeeDetail: CoffeeDetail?
    private(set) var isLoading = true
    private(set) var loadError: String?
    private var selectedSizeId: String?

    private let service: any CoffeeDetailsProviding
    private(set) var coffee: Coffee

    init(service: any CoffeeDetailsProviding, coffee: Coffee) {
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
            coffeeDetail = detail

            if let firstActiveSize = detail.sizes.first(where: { $0.isActive }) {
                selectedSizeId = firstActiveSize.id
            } else if let firstSize = detail.sizes.first {
                selectedSizeId = firstSize.id
                updateSelectedSize(firstSize.id)
            }

            isLoading = false
            loadError = nil
        } catch {
            isLoading = false
            coffeeDetail = nil
            loadError = error.localizedDescription
        }
    }

    func updateSelectedSize(_ sizeId: String) {
        guard let detail = coffeeDetail else { return }

        let updatedSizes = detail.sizes.map { size in
            CoffeeSize(
                id: size.id,
                name: size.name,
                isActive: size.id == sizeId
            )
        }

        coffeeDetail = CoffeeDetail(
            id: detail.id,
            categoryId: detail.categoryId,
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
    
    func handleRetryLoad() {
        loadError = nil
        isLoading = true
        Task {
            await fetchCoffeeDetail()
        }
    }
}
