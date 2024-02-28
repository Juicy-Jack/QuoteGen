//
//  Orginator.swift
//  CheckIMDb
//
//  Created by Furkan Doğan on 5.10.2023.
//

import Foundation

struct Originator: Identifiable, Codable {
    let id: Int
    let language_code: String
    let description: String
    let master_id: Int
    let name: String
    let url: String
}
