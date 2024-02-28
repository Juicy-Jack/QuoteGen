//
//  FavoritesView.swift
//  QuoteGen
//
//  Created by Furkan Doğan on 6.10.2023.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @ObservedObject var favorites: FavoriteQuotes
    
    init(favorites: FavoriteQuotes) {
        self.favorites = favorites
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            if favorites.quotes.isEmpty {
                Text("Your favorites will be shown here.")
                    .foregroundStyle(.secondary)
            } else {
                
                List {
                    ForEach(favorites.quotes) { quote in
                        NavigationLink {
                            QuoteDetailView(quote: quote)
                        } label: {
                            VStack {
                                Text(quote.content)
                                Text("-\(quote.originator.name)")
                            }
                        }
                        .padding()
                    }
                    .onDelete(perform: { indexSet in
                        favorites.removeQuote(atOffsets: indexSet)
                    })
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.thinMaterial))
                    .padding()
                }
                .listStyle(.plain)
            }
            
        }
        .navigationTitle("Favorites")
    }
}

/*
 #Preview {
 FavoritesView()
 }
 */
