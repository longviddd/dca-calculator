//
//  CalculatorTableViewController.swift
//  dca-calculator
//
//  Created by user195395 on 7/20/21.
//

import Foundation
import UIKit
class CalculatorTableViewController : UITableViewController{
    @IBOutlet weak var symbolLabel : UILabel!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    var asset : Asset?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    //setupViews func in order to add info to the labels
    private func setupViews(){
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency
            label.text = "(" + asset!.searchResult.currency + ")"
        }
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
        
    }
}
