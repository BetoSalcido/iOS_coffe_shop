// MARK: - Coffee detail preview helpers

import Foundation

extension DeveloperPreview {

    static let previewImageURL = URL(string: "https://images.pexels.com/photos/36673266/pexels-photo-36673266.jpeg?_gl=1*1srk2qj*_ga*MTU5MzgzNzIwMy4xNzgxMjIyNzAy*_ga_8JE65Q40S6*czE3ODEyMjI3MDIkbzEkZzEkdDE3ODEyMjI4MDYkajM4JGwwJGgw$0")!

    static func makeSizes(_ names: [String], activeIndex: Int) -> [CoffeeSize] {
        names.enumerated().map { index, name in
            CoffeeSize(id: "\(index + 1)", name: name, isActive: index == activeIndex)
        }
    }

    static func makeModifiers(_ names: [String]) -> [CoffeeModifier] {
        names.enumerated().map { index, name in
            CoffeeModifier(id: "m\(index + 1)", name: name, isActive: false)
        }
    }

    static func makeCoffeeDetail(
        id: String,
        categoryId: String,
        name: String,
        description: String,
        longDescription: String,
        rating: Double,
        price: Double,
        sizes: [CoffeeSize],
        modifiers: [CoffeeModifier]
    ) -> CoffeeDetail {
        CoffeeDetail(
            id: id,
            categoryId: categoryId,
            name: name,
            description: description,
            longDescription: longDescription,
            rating: rating,
            price: price,
            imageURL: previewImageURL,
            sizes: sizes,
            modifiers: modifiers
        )
    }
}
