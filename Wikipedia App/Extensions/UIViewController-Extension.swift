//
//  UIViewController-Extension.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 27/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    // MARK: - Alerts
    func showAlert(title: String, message: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present Alert Controller
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension UIViewController: NVActivityIndicatorViewable {
    
    internal func showLoader(){
        startAnimating(CGSize.init(width: 30, height: 30), message: "Please wait...", type: NVActivityIndicatorType.circleStrokeSpin)
    }
    
    internal func hideLoader(){
        stopAnimating()
    }
    
}
