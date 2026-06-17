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
    private(set) var isFavorite = false
    private(set) var favoriteActionError: String?
    private var selectedSizeId: String?

    private let service: any CoffeeDetailsProviding
    private let favoritesService: any FavoritesProviding
    private(set) var coffee: Coffee

    init(
        service: any CoffeeDetailsProviding,
        favoritesService: any FavoritesProviding,
        coffee: Coffee
    ) {
        self.service = service
        self.favoritesService = favoritesService
        self.coffee = coffee

        Task {
            await load()
        }
    }
}

// MARK: - Private Methods
private extension CoffeeDetailViewModel {

    func load() async {
        await fetchCoffeeDetail()
        await refreshFavoriteState()
    }

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

    func refreshFavoriteState() async {
        do {
            let ids = try await favoritesService.fetchFavoriteCoffeeIds()
            isFavorite = ids.contains(coffee.id)
        } catch is FavoritesError {
            isFavorite = false
        } catch {
            // Non-blocking: detail still works if favorites fail to load.
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
            await load()
        }
    }

    func handleFavoriteSelection() async {
        favoriteActionError = nil

        do {
            if isFavorite {
                try await favoritesService.removeFavorite(coffeeId: coffee.id)
                isFavorite = false
            } else {
                try await favoritesService.addFavorite(coffeeId: coffee.id)
                isFavorite = true
            }
        } catch {
            favoriteActionError = error.localizedDescription
        }
    }

    func clearFavoriteActionError() {
        favoriteActionError = nil
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
