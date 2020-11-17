//
//  PrimaryButton.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/21/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PrimaryButton: UIButton {
    @IBInspectable var padding: CGFloat = 10 {
        didSet {
            self.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
    }
}
