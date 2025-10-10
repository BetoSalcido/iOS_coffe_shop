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
            Color.init(hex: "#313131")
                .ignoresSafeArea(.all, edges: .top)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Location")
                    .font(.caption)
                    .foregroundStyle(.white)
                
                HStack {
                    Text("Culiacán, Sinaloa")
                        .font(.caption)
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
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 50)
            .padding(.bottom)
            
            // Banner image positioned at the bottom center
            VStack(alignment: .center) {
                Spacer()
                Image("BannerImage")
                    .imageScale(.large)
                    .offset(y: 110) // Adjust this value to position it between views
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 200)
    }
}

#Preview {
    HomeHeaderView()
}
