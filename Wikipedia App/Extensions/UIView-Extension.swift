//
//  UIView-Extension.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 27/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit


extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var showShadow: Bool {
        
        get {
            return false
        }
        set {
            self.clipsToBounds = true
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.layer.shadowRadius = 3.0
            self.layer.masksToBounds = false
        }
        
    }

}

