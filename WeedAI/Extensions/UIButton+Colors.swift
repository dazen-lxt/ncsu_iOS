//
//  UIButton+Colors.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

extension UIButton {
    func setImageColor(color: UIColor, for state: UIControl.State) {
        let image = self.image(for: state)
        self.setImage(image?.withRenderingMode(.alwaysTemplate), for: state)
        self.tintColor = color
    }
}
