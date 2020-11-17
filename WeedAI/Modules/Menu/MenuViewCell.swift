//
//  MenuViewCell.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

class MenuViewCell: UITableViewCell {
    
    
    @IBOutlet var menuImage: UIImageView!
    @IBOutlet var menuTitle: UILabel!
    
    func configureCell(titleCell: String, imageName: String) {
        menuImage.image = UIImage(named: imageName)
        menuTitle.text = titleCell
        menuImage.setImageColor(color: UIColor.Brand.darkGrayColor)
        contentView.backgroundColor = UIColor.clear
        menuTitle.textColor = UIColor.black
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        menuImage.setImageColor(color: selected ? UIColor.Brand.primaryColor : UIColor.Brand.darkGrayColor)
        contentView.backgroundColor = selected ? UIColor.Brand.lightGrayColor : UIColor.clear
        menuTitle.textColor = selected ? UIColor.Brand.primaryColor : UIColor.black
    }
}
