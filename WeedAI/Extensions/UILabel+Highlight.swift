//
//  UILabel+Highligth.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/24/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

extension UILabel {
    func highlight(searchedText: String?, color: UIColor = .red) {
        guard let txtLabel = self.text?.lowercased(), let searchedText = searchedText?.lowercased() else {
            return
        }

        let attributeTxt = NSMutableAttributedString(string: txtLabel)
        let range: NSRange = attributeTxt.mutableString.range(of: searchedText, options: .caseInsensitive)
        //attributeTxt.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "HelveticaNeue-Bold", size: self.font.pointSize)!, range: range)
        attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.attributedText = attributeTxt
    }

}
