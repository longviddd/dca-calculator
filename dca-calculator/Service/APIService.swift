//
//  APIService.swift
//  dca-calculator
//
//  Created by user195395 on 7/13/21.
//

import Foundation
import Combine

struct APIService {
    var API_KEY : String{
        //return random key since i'm using the free version
        return keys.randomElement() ?? ""
    }
    
    //create array of keys
    let keys = ["80DU9MSGEBELRL9G", "0IX0YZJRK1RTT5PM", "9JYT696PCTSOBHW0"]
    func fetchSymbolsPublisher(keywords : String) -> AnyPublisher<SearchResults, Error>  {
        let urlString =
            "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        let url = URL(string: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url).map({$0.data}).decode(type: SearchResults.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
    }
    
}
