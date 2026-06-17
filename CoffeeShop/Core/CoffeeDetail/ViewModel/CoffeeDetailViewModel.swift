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

        coffeeDetail = detail.updating(sizes: updatedSizes)
    }

    func toggleModifier(_ modifierId: String) {
        guard let detail = coffeeDetail else { return }

        let updatedModifiers = detail.modifiers.map { modifier in
            guard modifier.id == modifierId else { return modifier }
            return CoffeeModifier(
                id: modifier.id,
                name: modifier.name,
                isActive: !modifier.isActive
            )
        }

        coffeeDetail = detail.updating(modifiers: updatedModifiers)
    }
}

// MARK: - Public Methods
extension CoffeeDetailViewModel {

    func handleCoffeeSizeSelectionWith(_ size: CoffeeSize) {
        selectedSizeId = size.id
        updateSelectedSize(size.id)
    }

    func handleCoffeeModifierSelectionWith(_ modifier: CoffeeModifier) {
        toggleModifier(modifier.id)
    }

    func handleRetryLoad() {
        loadError = nil
        isLoading = true
        Task {
            await fetchCoffeeDetail()
        }
    }
}

// MARK: - CoffeeDetail updates
private extension CoffeeDetail {

    func updating(
        sizes: [CoffeeSize]? = nil,
        modifiers: [CoffeeModifier]? = nil
    ) -> CoffeeDetail {
        CoffeeDetail(
            id: id,
            categoryId: categoryId,
            name: name,
            description: description,
            longDescription: longDescription,
            rating: rating,
            price: price,
            imageURL: imageURL,
            sizes: sizes ?? self.sizes,
            modifiers: modifiers ?? self.modifiers
        )
    }
}
