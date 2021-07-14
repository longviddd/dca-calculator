//
//  UIAnimatable.swift
//  dca-calculator
//
//  Created by user195395 on 7/14/21.
//

import Foundation
import MBProgressHUD
protocol UIAnimatable where Self: UIViewController{
    func showLoadingAnimation()
    func hideLoadingAnimation()
}
extension UIAnimatable{
    func showLoadingAnimation(){
        DispatchQueue.main.async{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
    }
    func hideLoadingAnimation(){
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
