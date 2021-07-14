//
//  SearchTableViewCell.swift
//  dca-calculator
//
//  Created by user195395 on 7/12/21.
//

import Foundation
import UIKit
class SearchTableViewCell : UITableViewCell{
    @IBOutlet weak var assetNameLabel : UILabel!
    @IBOutlet weak var assetSymbolLabel : UILabel!
    @IBOutlet weak var assetTypeLabel : UILabel!
    //function to configure the labels
    func configure(with searchResult : SearchResult){
        assetNameLabel.text = searchResult.name
        assetSymbolLabel.text = searchResult.symbol
        assetTypeLabel.text = searchResult.type
            .appending(" ")
            .appending(searchResult.currency)
    }
}
