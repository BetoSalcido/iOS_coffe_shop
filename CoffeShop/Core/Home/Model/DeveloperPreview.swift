//
//  DeveloperPreview.swift
//  CoffeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import Foundation

class DeveloperPreview {
    
    var categories: [CoffeeCategory] = [
        CoffeeCategory(id: UUID().uuidString, name: "All Coffee", isActive: true),
        CoffeeCategory(id: UUID().uuidString, name: "Machiato", isActive: false),
        CoffeeCategory(id: UUID().uuidString, name: "Latte", isActive: false),
        CoffeeCategory(id: UUID().uuidString, name: "Americano", isActive: false),
    ]
    
    let coffees: [Coffee] = [
        Coffee(
            id: UUID().uuidString,
            name: "Coffe Panna",
            description: "Espresso con crema batida",
            rating: 4.6,
            price: 3.50,
            imageURL: "CaffePanna"
        ),
        Coffee(
            id: UUID().uuidString,
            name: "Flat White",
            description: "Espresso con leche vaporizada",
            rating: 4.8,
            price: 4.00,
            imageURL: "FlatWhiteImage"
        ),
        Coffee(
            id: UUID().uuidString,
            name: "Mocha Fusi",
            description: "Chocolate con espresso caliente",
            rating: 4.7,
            price: 4.20,
            imageURL: "MochaFusi"
        ),
        Coffee(
            id: UUID().uuidString,
            name: "Mocha",
            description: "Café con leche y chocolate",
            rating: 4.5,
            price: 3.80,
            imageURL: "MochaImage"
        ),
        Coffee(
            id: UUID().uuidString,
            name: "Capuchino",
            description: "Espresso con espuma de leche",
            rating: 4.9,
            price: 3.90,
            imageURL: "CaffePanna"
        )
    ]


}
