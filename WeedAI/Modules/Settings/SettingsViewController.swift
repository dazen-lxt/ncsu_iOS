//
//  SettingsViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    public static func getInstance() -> SettingsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }
    
}
