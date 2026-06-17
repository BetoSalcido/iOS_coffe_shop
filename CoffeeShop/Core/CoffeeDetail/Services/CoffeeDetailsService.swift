//
//  CoffeeDetailsService.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 17/06/26.
//

import Foundation

final class CoffeeDetailsService: CoffeeDetailsProviding {

    func fetchCoffeeDetail(_ coffeeId: String) async throws -> CoffeeDetail {
        let coffees = DeveloperPreview().coffeeDetails
        return coffees.first(where: { $0.id == coffeeId }) ?? coffees[0]
    }
}
