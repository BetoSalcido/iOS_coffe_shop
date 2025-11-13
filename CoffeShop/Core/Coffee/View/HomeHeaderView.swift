//
//  HomeHeaderView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 09/10/25.
//

import SwiftUI

struct HomeHeaderView: View {
    @State private var searchCoffe = ""
    
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
                    HStack() {
                        Image("SearchIcon")
                            .imageScale(.small)
                        
                        TextField(
                            "Search coffee",
                            text: $searchCoffe,
                            prompt: Text("Search coffee").foregroundStyle(Color.init(hex:"#909090"))
                        )
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .accentColor(.white)
                        .onSubmit {
                            print("OnSubtmit")
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

#Preview {
    HomeHeaderView()
}
