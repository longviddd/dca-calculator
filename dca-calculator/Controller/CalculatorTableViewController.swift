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
    @IBOutlet weak var assetNameLabel : UILabel!
    var asset : Asset?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
