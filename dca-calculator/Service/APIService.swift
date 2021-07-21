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
    enum APIServiceError : Error{
        case encoding
        case badRequest
    }
    
    //create array of keys
    let keys = ["80DU9MSGEBELRL9G", "0IX0YZJRK1RTT5PM", "9JYT696PCTSOBHW0"]
    func fetchSymbolsPublisher(keywords : String) -> AnyPublisher<SearchResults, Error>  {
        var symbol = String()
        let result = parseQuery(text: keywords)
        switch result{
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        let urlString =
            "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(API_KEY)"
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult{
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url).map({$0.data}).decode(type: SearchResults.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    func fetchTimeSeriesMonthlyAdjustedPublisher(keywords: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error>{
        let result = parseQuery(text: keywords)
        var symbol = String()
        //switch in order to check whether parsing query was successful
        switch result{
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        let urlString =
            "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_KEY)"
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult{
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url).map({$0.data}).decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
    }
    
    private func parseQuery(text:String) -> Result<String,Error>{
        //function in order to check whether the query has space in it.
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
            return .success(query)
        }
        else{
            return .failure(APIServiceError.encoding)
        }
    }
    private func parseURL(urlString : String) -> Result<URL, Error>{
        //check if can parse URL. return url if able, error if not.
        if let url = URL(string: urlString){
            return .success((url))
        }
        else{
            return .failure(APIServiceError.badRequest)
        }
    }
    
    
}
