//
//  ContentView.swift
//  CheckIMDb
//
//  Created by Furkan Doğan on 5.10.2023.
//
import SwiftUI

struct ContentView: View {
    @StateObject var favoriteQuotes = FavoriteQuotes()
    @StateObject var viewModel = ViewModel()
    @StateObject var network = Network()
    @State private var langCode: languageCode = .en
    @State private var isFavorited = false
    @State private var isShowingNetworkAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if network.connected || viewModel.quote?.content != nil{
                    VStack {
                        if viewModel.quote?.content == nil {
                            ProgressView()
                        } else {
                            VStack {
                                NavigationLink {
                                    QuoteDetailView(quote: viewModel.quote!)
                                } label: {
                                    VStack {
                                        VStack(alignment: .trailing) {
                                            Group {
                                                Text(viewModel.quote!.content)
                                                    .font(.title)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundStyle(.foreground)
                                                    .padding([.top, .trailing, .leading])
                                                
                                                Text("-\(viewModel.quote!.originator.name)")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.foreground)
                                                    .padding([.leading, .trailing, .bottom])
                                            }
                                        }
                                        .background {
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundStyle(.thinMaterial)
                                        }
                                        .padding()
                                    }
                                }
                                
                                Button("New Quote") {
                                    if network.connected {
                                        Task {
                                            isFavorited = false
                                            await viewModel.fetchData()
                                        }
                                    } else {
                                        isShowingNetworkAlert = true
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.pink)
                                
                                Picker("Change Language", selection: $langCode) {
                                    ForEach(languageCode.allCases, id:\.self) { code in
                                        let menuText = code.showLangs()
                                        Text(menuText)
                                    }
                                }
                                .accentColor(.mint)
                            }
                            .alert("There is no network connection.", isPresented: $isShowingNetworkAlert) {
                                        Button("OK", role: .cancel) { }
                            } message: {
                                Text("Please connect to internet.")
                            }
                            .onAppear {
                                isFavorited = favoriteQuotes.quotes.contains(viewModel.quote!)
                            }
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        if isFavorited == false {
                                            favoriteQuotes.addNewQuote(newQuote: viewModel.quote!)
                                        } else {
                                            favoriteQuotes.removeQuote(quote: viewModel.quote!)
                                        }
                                        withAnimation {
                                            isFavorited.toggle()
                                        }
                                    } label: {
                                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                                            .foregroundStyle(.pink)
                                    }
                                    .accessibilityLabel("Add quote to favorites")
                                }
                                
                                ToolbarItem(placement: .topBarTrailing) {
                                    NavigationLink {
                                        FavoritesView(favorites: favoriteQuotes)
                                    } label: {
                                        Image(systemName: "list.bullet")
                                            .foregroundStyle(.pink)
                                    }
                                    .accessibilityLabel("View your favorite quotes.")
                                }
                            }
                        }
                    }
                } else {
                    VStack {
                        Text("There is no network connection.")
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                FavoritesView(favorites: favoriteQuotes)
                            } label: {
                                Image(systemName: "list.bullet")
                                    .foregroundStyle(.pink)
                            }
                            .accessibilityLabel("View your favorite quotes.")
                        }
                    }
                }
            }
        }
        .onChange(of: langCode) { newLangCode in
            changeLang(lang: newLangCode)
        }
        .onChange(of: network.connected) { newStatus in
            if newStatus {
                Task {
                    await viewModel.fetchData()
                }
            }
        }
    }
    
    enum languageCode: CaseIterable {
        case en
        case es
        case it
        case pt
        case de
        case fr
        case cs
        case sk
        
        func showLangs() -> String {
            switch(self) {
            case .en:
                return "English"
            case .es:
                return "Española"
            case .it:
                return "Italiana"
            case .pt:
                return "Portugues"
            case .de:
                return "Deutsche"
            case .fr:
                return "Française"
            case .cs:
                return "čeština"
            case .sk:
                return "Slovenčina"
            }
        }
        
    }
    
    func changeLang(lang: languageCode) {
        switch langCode {
        case .en:
            viewModel.langCode = "en"
        case .es:
            viewModel.langCode = "es"
        case .it:
            viewModel.langCode = "it"
        case .pt:
            viewModel.langCode = "pt"
        case .de:
            viewModel.langCode = "de"
        case .fr:
            viewModel.langCode = "fr"
        case .cs:
            viewModel.langCode = "cs"
        case .sk:
            viewModel.langCode = "sk"
        }
    }
}


#Preview {
    ContentView()
}
