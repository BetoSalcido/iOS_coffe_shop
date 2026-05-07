//
//  CatalogTopSection.swift
//  CoffeeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

/// Location, search, and promo banner as a single unit at the top of the catalog.
struct CatalogTopSection: View {
    var body: some View {
        VStack(spacing: 0) {
            CatalogHeaderChrome()
            CatalogPromoBanner()
        }
    }
}

// MARK: - Private pieces
private struct CatalogHeaderChrome: View {
    @State private var searchCoffee = ""

    var body: some View {
        ZStack(alignment: .leading) {
            Color.Background.dark

            VStack(alignment: .leading, spacing: 10) {
                Text("Location")
                    .font(.footnote)
                    .foregroundStyle(.white)

                HStack {
                    Text("Culiacán, Sinaloa")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)

                    Image(systemName: "chevron.compact.down")
                        .imageScale(.small)
                        .foregroundStyle(.white)
                }

                HStack(spacing: 12) {
                    HStack {
                        Image("SearchIcon")
                            .imageScale(.small)

                        TextField(
                            "Search coffee",
                            text: $searchCoffee,
                            prompt: Text("Search coffee").foregroundStyle(Color.init(hex: "#909090"))
                        )
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .accentColor(.white)
                        .onSubmit {
                            print("OnSubmit")
                        }
                    }
                    .frame(height: 52)
                    .padding(.horizontal)
                    .background(Color.init(hex: "#2A2A2A"))
                    .cornerRadius(16)

                    Button {
                        print("Settings Selected")
                    } label: {
                        Image("FiletIcon")
                            .imageScale(.large)
                    }
                }
                .frame(height: 44)
                .padding(.vertical)
            }
            .padding(.horizontal)
        }
        .frame(height: 150, alignment: .bottom)
    }
}

private struct CatalogPromoBanner: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.init(hex: "#313131")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Color.white
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Image("BannerImage")
                .imageScale(.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 150)
        .clipped()
    }
}

#Preview {
    CatalogTopSection()
}
