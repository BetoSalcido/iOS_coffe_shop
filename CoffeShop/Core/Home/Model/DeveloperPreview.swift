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
            longDescription: "Coffee Panna is an espresso topped with a layer of lightly whipped cream. Typically served in a small cup of about 60–90 ml, it balances the intensity of espresso with the smooth sweetness of cream, creating a rich and velvety experience.",
            rating: 4.6,
            price: 3.50,
            imageURL: "CaffePanna"
        ),
        Coffee(
            id: UUID().uuidString,
            name: "Flat White",
            description: "Espresso con leche vaporizada",
            longDescription: "A Flat White is a smooth blend of espresso and finely textured steamed milk. Usually around 160 ml (5.5 oz), it has a thin layer of microfoam and a rich espresso base, providing a creamy texture with a strong coffee flavor.",
            rating: 4.8,
            price: 4.00,
            imageURL: "FlatWhiteImage"
        ),
        Coffee(
            id: UUID().uuidString,
            name: "Mocha Fusi",
            description: "Chocolate con espresso caliente",
            longDescription: "Mocha Fusi combines rich chocolate syrup with espresso and steamed milk, creating a 200 ml (7 oz) beverage that blends sweetness with a deep coffee profile. Often topped with whipped cream or cocoa powder for extra indulgence.",
            rating: 4.7,
            price: 4.20,
            imageURL: "MochaFusi"
        ),
        Coffee(
            id: UUID().uuidString,
            name: "Mocha",
            description: "Café con leche y chocolate",
            longDescription: "A Mocha is a harmonious mix of espresso, steamed milk, and chocolate. Served in a cup of about 250 ml (8 oz), it offers the perfect balance between the richness of cocoa and the strength of coffee, often finished with foam or whipped cream.",
            rating: 4.5,
            price: 3.80,
            imageURL: "MochaImage"
        ),
        Coffee(
            id: UUID().uuidString,
            name: "Capuchino",
            description: "Espresso con espuma de leche",
            longDescription: "A Cappuccino is an approximately 150 ml (5 oz) beverage made with 25 ml of espresso, 85 ml of steamed milk, and a thick layer of milk foam. It offers a perfect balance of bold espresso and creamy texture, often dusted with cocoa powder.",
            rating: 4.9,
            price: 3.90,
            imageURL: "CaffePanna"
        )
    ]


}
