//
//  SplashView.swift
//  CoffeShop
//
//  Created by Beto Salcido on 06/10/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                GeometryReader { geo in
                    Image("SplashBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height / 1.6)
                }

                VStack {
                    VStack(spacing: 16) {
                        Text("Fall in Love with\nCoffee in Blissful\nDelight!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                            

                        Text("Welcome to our cozy coffee corner, where\nevery cup is a delightful for you.")
                            .font(.body)
                            .foregroundStyle(.white.opacity(0.60))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)

                        NavigationLink {
                            Text("Beto")
                        } label: {
                            Text("Get Started")
                                .font(.headline)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(Color(hex: "#C67C4E"))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .top)
            }
        }
    }
}

#Preview {
    SplashView()
}
