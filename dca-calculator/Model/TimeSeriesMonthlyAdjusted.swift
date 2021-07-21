//
//  TimeSeriesMonthlyAdjusted.swift
//  dca-calculator
//
//  Created by user195395 on 7/18/21.
//

import Foundation
struct MonthInfo{
    //create MonthInfo struct in order to sort out what we need from the TimeSeriesMonthlyAdjusted struct
    let date : Date
    let adjustedOpen : Double
    let adjustedClose :Double
}

struct TimeSeriesMonthlyAdjusted : Decodable{
    let meta : Meta
    let timeSeries : [String : OHLC]
    enum CodingKeys : String, CodingKey{
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    func getMonthInfos() -> [MonthInfo]{
        //function in order to get MonthInfo class out of timeseries
        var monthInfos : [MonthInfo] = []
        let sortedTimeSeries = timeSeries.sorted(by: {$0.key > $1.key})
        sortedTimeSeries.forEach{(dateString, ohlc) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)!
            let adjustedOpen = getAdjustedOpen(ohlc: ohlc)
            //create dateformatter to obtain the date from the dateString
            let monthInfo = MonthInfo(date: date, adjustedOpen: adjustedOpen, adjustedClose: Double(ohlc.adjustedClose)!)
            monthInfos.append(monthInfo)
        }
        return monthInfos
    }
    private func getAdjustedOpen(ohlc: OHLC) -> Double{
        //create getadjustedopen function because it is not in the GET call
        // Formula: adjusted open = open * (adjusted close / close)
        return Double(ohlc.open)! * (Double(ohlc.adjustedClose)! / Double(ohlc.close)!)
    }
}

struct Meta : Decodable{
    let symbol : String
    enum CodingKeys : String, CodingKey{
        case symbol = "2. Symbol"
    }
    
}
struct OHLC : Decodable{
    let open : String
    let close : String
    let adjustedClose : String
    enum CodingKeys : String, CodingKey{
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}
