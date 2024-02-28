//
//  QuoteDetailView.swift
//  QuoteGen
//
//  Created by Furkan Doğan on 5.10.2023.
//

import SwiftUI

struct QuoteDetailView: View {
    var quote: Quote
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .trailing) {
                    Text("\(quote.content)")
                        .font(.title2)
                    Text("-\(quote.originator.name)")
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.thinMaterial)
                }
                .padding()

                Section {
                    VStack {
                        Text("About \(quote.originator.name)")
                            .font(.headline)
                        Text(quote.originator.description.isEmpty ? "I can't find any information about \(quote.originator.name)" : quote.originator.description)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.thinMaterial)
                            .shadow(radius: 3)
                    }
                }
                .padding()

                Section {
                    Text("Tags: \(quote.tags.joined(separator: ", ")).")
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.thinMaterial)
                }
            }
        }
        .navigationTitle("Details")
    }
}

#Preview {
    
    NavigationView {
        QuoteDetailView(quote: Quote.example)
    }
}
