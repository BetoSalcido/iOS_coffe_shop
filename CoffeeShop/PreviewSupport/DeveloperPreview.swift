//
//  DeveloperPreview.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 13/10/25.
//

import Foundation

/// Sample catalog data for SwiftUI previews and the mock `CoffeeCatalogService` implementation.
/// Category UUIDs match `supabase/migrations/001_catalog.sql`.
final class DeveloperPreview {

    static let categoryAllCoffee = "a1000001-0001-4001-8001-000000000001"
    static let categoryMachiato = "a1000001-0001-4001-8001-000000000002"
    static let categoryLatte = "a1000001-0001-4001-8001-000000000003"
    static let categoryAmericano = "a1000001-0001-4001-8001-000000000004"

    private static let defaultSizes: [CoffeeSize] = [
        CoffeeSize(id: "1", name: "S", isActive: false),
        CoffeeSize(id: "2", name: "M", isActive: false),
        CoffeeSize(id: "3", name: "L", isActive: false),
    ]

    var categories: [CoffeeCategory] = [
        CoffeeCategory(id: categoryAllCoffee, name: "All Coffee", isActive: true, isAllFilter: true),
        CoffeeCategory(id: categoryMachiato, name: "Machiato", isActive: false),
        CoffeeCategory(id: categoryLatte, name: "Latte", isActive: false),
        CoffeeCategory(id: categoryAmericano, name: "Americano", isActive: false),
    ]

    let coffees: [Coffee] = [
        Coffee(
            id: "b2000001-0001-4001-8001-000000000001",
            categoryId: categoryAmericano,
            name: "Coffee Panna",
            description: "Espresso con crema batida",
            longDescription: "Coffee Panna is an espresso topped with a layer of lightly whipped cream. Typically served in a small cup of about 60–90 ml, it balances the intensity of espresso with the smooth sweetness of cream, creating a rich and velvety experience.",
            rating: 4.6,
            price: 3.50,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: [
                CoffeeSize(id: "1", name: "S", isActive: false),
                CoffeeSize(id: "2", name: "M", isActive: false),
                CoffeeSize(id: "3", name: "L", isActive: false),
            ]
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000002",
            categoryId: categoryLatte,
            name: "Flat White",
            description: "Espresso con leche vaporizada",
            longDescription: "A Flat White is a smooth blend of espresso and finely textured steamed milk. Usually around 160 ml (5.5 oz), it has a thin layer of microfoam and a rich espresso base, providing a creamy texture with a strong coffee flavor.",
            rating: 4.8,
            price: 4.00,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: [
                CoffeeSize(id: "1", name: "S", isActive: false),
                CoffeeSize(id: "2", name: "M", isActive: false),
                CoffeeSize(id: "3", name: "L", isActive: false),
            ]
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000003",
            categoryId: categoryLatte,
            name: "Mocha Fusi",
            description: "Chocolate con espresso caliente",
            longDescription: "Mocha Fusi combines rich chocolate syrup with espresso and steamed milk, creating a 200 ml (7 oz) beverage that blends sweetness with a deep coffee profile. Often topped with whipped cream or cocoa powder for extra indulgence.",
            rating: 4.7,
            price: 4.20,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: [
                CoffeeSize(id: "1", name: "S", isActive: false),
                CoffeeSize(id: "2", name: "M", isActive: false),
                CoffeeSize(id: "3", name: "L", isActive: false),
            ]
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000004",
            categoryId: categoryLatte,
            name: "Mocha",
            description: "Café con leche y chocolate",
            longDescription: "A Mocha is a harmonious mix of espresso, steamed milk, and chocolate. Served in a cup of about 250 ml (8 oz), it offers the perfect balance between the richness of cocoa and the strength of coffee, often finished with foam or whipped cream.",
            rating: 4.5,
            price: 3.80,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: [
                CoffeeSize(id: "1", name: "S", isActive: false),
                CoffeeSize(id: "2", name: "M", isActive: false),
                CoffeeSize(id: "3", name: "L", isActive: false),
            ]
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000005",
            categoryId: categoryMachiato,
            name: "Capuchino",
            description: "Espresso con espuma de leche",
            longDescription: "A Cappuccino is an approximately 150 ml (5 oz) beverage made with 25 ml of espresso, 85 ml of steamed milk, and a thick layer of milk foam. It offers a perfect balance of bold espresso and creamy texture, often dusted with cocoa powder.",
            rating: 4.9,
            price: 3.90,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000006",
            categoryId: categoryAmericano,
            name: "Americano Classico",
            description: "Espresso diluido con agua caliente",
            longDescription: "A classic Americano combines a double shot of espresso with hot water, yielding a smooth, full-bodied cup around 240 ml. It preserves the espresso's crema while offering a lighter mouthfeel than a straight shot—ideal for slow sipping.",
            rating: 4.4,
            price: 3.20,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000007",
            categoryId: categoryAmericano,
            name: "Espresso Doppio",
            description: "Doble shot de espresso intenso",
            longDescription: "Espresso Doppio is a double shot pulled into a small demitasse—about 60 ml of concentrated coffee with a rich crema layer. Bold, aromatic, and the foundation for most milk-based drinks on our menu.",
            rating: 4.7,
            price: 2.90,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000008",
            categoryId: categoryLatte,
            name: "Caramel Latte",
            description: "Latte con jarabe de caramelo",
            longDescription: "Steamed milk meets espresso and buttery caramel syrup in this 350 ml favorite. Sweet but balanced, with a silky microfoam finish and optional caramel drizzle for extra indulgence.",
            rating: 4.6,
            price: 4.50,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000009",
            categoryId: categoryLatte,
            name: "Vanilla Latte",
            description: "Latte con esencia de vainilla",
            longDescription: "A comforting blend of espresso, steamed milk, and Madagascar vanilla syrup. Served around 350 ml with a light foam cap—creamy, fragrant, and gently sweet without overpowering the coffee.",
            rating: 4.5,
            price: 4.30,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000010",
            categoryId: categoryLatte,
            name: "Café Mocha",
            description: "Chocolate belga con espresso",
            longDescription: "Our signature Café Mocha layers dark chocolate, espresso, and steamed milk in a 300 ml cup. Topped with whipped cream and cocoa dust for a dessert-like treat that still delivers a proper coffee kick.",
            rating: 4.8,
            price: 4.60,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000011",
            categoryId: categoryMachiato,
            name: "Macchiato",
            description: "Espresso manchado con espuma de leche",
            longDescription: "A true macchiato—“marked” with a spoonful of velvety milk foam atop a single espresso shot. Roughly 90 ml total, intense and quick, perfect when you want espresso with just a touch of creaminess.",
            rating: 4.7,
            price: 3.40,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        Coffee(
            id: "b2000001-0001-4001-8001-000000000012",
            categoryId: categoryMachiato,
            name: "Cortado",
            description: "Espresso con leche al vapor",
            longDescription: "The Cortado balances equal parts espresso and warm steamed milk in a small glass—about 120 ml. Less foam than a cappuccino, more coffee forward than a latte, with a smooth, rounded finish.",
            rating: 4.6,
            price: 3.70,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
    ]
    
    let coffeeDetails: [CoffeeDetail] = [
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000001",
            categoryId: categoryAmericano,
            name: "Coffee Panna",
            description: "Espresso con crema batida",
            longDescription: "Coffee Panna is an espresso topped with a layer of lightly whipped cream. Typically served in a small cup of about 60–90 ml, it balances the intensity of espresso with the smooth sweetness of cream, creating a rich and velvety experience.",
            rating: 4.6,
            price: 3.50,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: [
                CoffeeSize(id: "1", name: "S", isActive: false),
                CoffeeSize(id: "2", name: "M", isActive: false),
                CoffeeSize(id: "3", name: "L", isActive: false),
            ]
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000002",
            categoryId: categoryLatte,
            name: "Flat White",
            description: "Espresso con leche vaporizada",
            longDescription: "A Flat White is a smooth blend of espresso and finely textured steamed milk. Usually around 160 ml (5.5 oz), it has a thin layer of microfoam and a rich espresso base, providing a creamy texture with a strong coffee flavor.",
            rating: 4.8,
            price: 4.00,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: [
                CoffeeSize(id: "1", name: "S", isActive: false),
                CoffeeSize(id: "2", name: "M", isActive: false),
                CoffeeSize(id: "3", name: "L", isActive: false),
            ]
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000003",
            categoryId: categoryLatte,
            name: "Mocha Fusi",
            description: "Chocolate con espresso caliente",
            longDescription: "Mocha Fusi combines rich chocolate syrup with espresso and steamed milk, creating a 200 ml (7 oz) beverage that blends sweetness with a deep coffee profile. Often topped with whipped cream or cocoa powder for extra indulgence.",
            rating: 4.7,
            price: 4.20,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: [
                CoffeeSize(id: "1", name: "S", isActive: false),
                CoffeeSize(id: "2", name: "M", isActive: false),
                CoffeeSize(id: "3", name: "L", isActive: false),
            ]
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000004",
            categoryId: categoryLatte,
            name: "Mocha",
            description: "Café con leche y chocolate",
            longDescription: "A Mocha is a harmonious mix of espresso, steamed milk, and chocolate. Served in a cup of about 250 ml (8 oz), it offers the perfect balance between the richness of cocoa and the strength of coffee, often finished with foam or whipped cream.",
            rating: 4.5,
            price: 3.80,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: [
                CoffeeSize(id: "1", name: "S", isActive: false),
                CoffeeSize(id: "2", name: "M", isActive: false),
                CoffeeSize(id: "3", name: "L", isActive: false),
            ]
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000005",
            categoryId: categoryMachiato,
            name: "Capuchino",
            description: "Espresso con espuma de leche",
            longDescription: "A Cappuccino is an approximately 150 ml (5 oz) beverage made with 25 ml of espresso, 85 ml of steamed milk, and a thick layer of milk foam. It offers a perfect balance of bold espresso and creamy texture, often dusted with cocoa powder.",
            rating: 4.9,
            price: 3.90,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000006",
            categoryId: categoryAmericano,
            name: "Americano Classico",
            description: "Espresso diluido con agua caliente",
            longDescription: "A classic Americano combines a double shot of espresso with hot water, yielding a smooth, full-bodied cup around 240 ml. It preserves the espresso's crema while offering a lighter mouthfeel than a straight shot—ideal for slow sipping.",
            rating: 4.4,
            price: 3.20,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000007",
            categoryId: categoryAmericano,
            name: "Espresso Doppio",
            description: "Doble shot de espresso intenso",
            longDescription: "Espresso Doppio is a double shot pulled into a small demitasse—about 60 ml of concentrated coffee with a rich crema layer. Bold, aromatic, and the foundation for most milk-based drinks on our menu.",
            rating: 4.7,
            price: 2.90,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000008",
            categoryId: categoryLatte,
            name: "Caramel Latte",
            description: "Latte con jarabe de caramelo",
            longDescription: "Steamed milk meets espresso and buttery caramel syrup in this 350 ml favorite. Sweet but balanced, with a silky microfoam finish and optional caramel drizzle for extra indulgence.",
            rating: 4.6,
            price: 4.50,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000009",
            categoryId: categoryLatte,
            name: "Vanilla Latte",
            description: "Latte con esencia de vainilla",
            longDescription: "A comforting blend of espresso, steamed milk, and Madagascar vanilla syrup. Served around 350 ml with a light foam cap—creamy, fragrant, and gently sweet without overpowering the coffee.",
            rating: 4.5,
            price: 4.30,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000010",
            categoryId: categoryLatte,
            name: "Café Mocha",
            description: "Chocolate belga con espresso",
            longDescription: "Our signature Café Mocha layers dark chocolate, espresso, and steamed milk in a 300 ml cup. Topped with whipped cream and cocoa dust for a dessert-like treat that still delivers a proper coffee kick.",
            rating: 4.8,
            price: 4.60,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000011",
            categoryId: categoryMachiato,
            name: "Macchiato",
            description: "Espresso manchado con espuma de leche",
            longDescription: "A true macchiato—“marked” with a spoonful of velvety milk foam atop a single espresso shot. Roughly 90 ml total, intense and quick, perfect when you want espresso with just a touch of creaminess.",
            rating: 4.7,
            price: 3.40,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
        CoffeeDetail(
            id: "b2000001-0001-4001-8001-000000000012",
            categoryId: categoryMachiato,
            name: "Cortado",
            description: "Espresso con leche al vapor",
            longDescription: "The Cortado balances equal parts espresso and warm steamed milk in a small glass—about 120 ml. Less foam than a cappuccino, more coffee forward than a latte, with a smooth, rounded finish.",
            rating: 4.6,
            price: 3.70,
            imageURL: URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!,
            sizes: DeveloperPreview.defaultSizes
        ),
    ]
}
