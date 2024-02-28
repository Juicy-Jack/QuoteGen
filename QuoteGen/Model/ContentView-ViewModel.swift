//
//  ContextViewViewModel.swift
//  CheckIMDb
//
//  Created by Furkan Doğan on 5.10.2023.
//

import Foundation
import SwiftUI

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        var langCode = "en"
        @Published private(set) var quote: Quote?
        init() {
            Task.init {
                await fetchData()
            }
        }
        

        
        let headers = [
            "X-RapidAPI-Key": "4711fb200cmsh9d3bc47d28c410dp1742dfjsncfb06f6e70bb",
            "X-RapidAPI-Host": "quotes15.p.rapidapi.com"
        ]
        
        func fetchData() async {
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://quotes15.p.rapidapi.com/quotes/random/?language_code=\(langCode)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                guard let data = data else { return }
                do {
                    let decoded = try JSONDecoder().decode(Quote.self, from: data)
                    DispatchQueue.main.async {
                        self.quote = decoded
                    }
                } catch {
                    print(error.localizedDescription)
                }
            })
            
            dataTask.resume()
        }
    }
}

