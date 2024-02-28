//
//  Quote.swift
//  CheckIMDb
//
//  Created by Furkan Doğan on 5.10.2023.
//

import Foundation

struct Quote: Codable, Identifiable, Equatable {
    static func == (lhs: Quote, rhs: Quote) -> Bool {
        rhs.id == lhs.id
    }
    
    let id: Int
    let originator: Originator
    let language_code: String
    let content: String
    let url: String
    let tags: [String]
    
    static let exampleOriginator = Originator(id: 22, language_code: "en", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ac lobortis elit. Fusce viverra massa nulla, cursus sollicitudin nibh pulvinar vel. Vestibulum vel quam malesuada, fermentum elit at, maximus lacus. Aliquam erat volutpat. Fusce euismod risus sed dapibus sagittis. Quisque porta mattis dapibus. Ut tempus ipsum vitae tellus congue eleifend. Vivamus pellentesque semper mollis. Sed sollicitudin libero non ligula efficitur, nec tristique magna congue. Pellentesque facilisis, justo sed accumsan vestibulum, diam metus sodales dolor, vel congue nulla odio ac felis. Nulla efficitur nisl justo, vel finibus enim interdum pellentesque. Phasellus volutpat imperdiet magna, nec tristique eros interdum ut. Ut lectus.", master_id: 77, name: "Furki", url: "furkido.com")
    static let example = Quote(id: 00, originator: exampleOriginator, language_code: "en", content: "iç çayını, sik karını", url: "furkido.com", tags: ["hakikatli", "gerçekçi", "hayatın içinden"])
}

@MainActor class FavoriteQuotes: ObservableObject {
    @Published private(set) var quotes: [Quote]
    let saveKey = "FavoriteQuotes"
    let savePath = FileManager.documentsDirectory.appendingPathComponent("FavoriteQuotes")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            quotes = try JSONDecoder().decode([Quote].self, from: data)
        } catch {
            quotes = []
        }
    }
    
    func addNewQuote(newQuote: Quote) {
        quotes.append(newQuote)
        save()
    }
    
    func removeQuote(atOffsets: IndexSet) {
        quotes.remove(atOffsets: atOffsets)
        save()
    }
    
    func removeQuote(quote: Quote) {
        let index = quotes.firstIndex(of: quote)
        quotes.remove(at: index!)
        save()
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(quotes)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}
