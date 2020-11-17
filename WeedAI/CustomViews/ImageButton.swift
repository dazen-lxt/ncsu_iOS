//
//  ImageButton.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/22/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ImageButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.cornerRadius
    }
}

