//
//  SearchResults.swift
//  dca-calculator
//
//  Created by user195395 on 7/13/21.
//

import Foundation
//create a class in order to store arrays of result
struct SearchResults : Decodable{
    let items : [SearchResult]
    enum CodingKeys : String, CodingKey {
        case items = "bestMatches"
    }
}
//array of result
struct SearchResult : Decodable{
    let symbol : String
    let name : String
    let type : String
    let currency : String
    enum CodingKeys : String, CodingKey{
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case currency = "8. currency"
    }
}
