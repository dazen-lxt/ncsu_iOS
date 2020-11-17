//
//  MapViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

class HistoricViewController: UIViewController {
    
    public static func getInstance() -> HistoricViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Historic"
    }

}
