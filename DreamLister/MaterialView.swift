//
//  File.swift
//  DreamLister
//
//  Created by Munene Kaumbutho on 2017-05-22.
//  Copyright © 2017 Munene Kaumbutho. All rights reserved.
//

import Foundation
import UIKit

private var materialKey = false

extension UIView {
    @IBInspectable var materialDesign: Bool {
        get {
           return materialKey
        } set {
            meterialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0)
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowOffset = nil
            }
        }
        
    }
}
