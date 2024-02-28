//
//  FileManager-DocumentsDirectory.swift
//  QuoteGen
//
//  Created by Furkan Doğan on 7.10.2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
