//
//  CatalogVisualMetrics.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 07/05/26.
//

import SwiftUI

/// Layout and styling constants for the coffee catalog feature (chips, grid, cards).
enum CatalogVisualMetrics {

    enum CategoryChip {
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 10
        static let cornerRadius: CGFloat = 10
    }

    enum Grid {
        static let columnMinimumWidth: CGFloat = 160
        static let spacing: CGFloat = 16
        static let outerPadding: CGFloat = 16
        static let cellClipCornerRadius: CGFloat = 16
    }

    enum CoffeeCard {
        static let contentSpacing: CGFloat = 6
        static let imageHeight: CGFloat = 128
        static let imageCornerRadius: CGFloat = 14
        static let ratingStarIconSpacing: CGFloat = 4
        static let ratingBadgePadding: CGFloat = 6
        static let ratingBadgeOuterPadding: CGFloat = 8
        static let outerPadding: CGFloat = 12
        static let outerCornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 2
        static let shadowYOffset: CGFloat = 1
        static let addButtonSide: CGFloat = 32
    }
}
