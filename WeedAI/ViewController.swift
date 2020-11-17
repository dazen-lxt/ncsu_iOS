//
//  ViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/12/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var drawerVC: DrawerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootController = RootViewController(mainViewController: HomeViewController.getInstance())
        let menuVC = MenuViewController.getInstance(delegate: self)
        drawerVC = DrawerController(rootViewController: rootController, menuController: menuVC)
        self.addChild(drawerVC)
        view.addSubview(drawerVC.view)
        drawerVC.didMove(toParent: self)
        UIApplication.shared.delegate?.window??.tintColor = UIColor.white
    }

}

extension ViewController: MenuViewControllerProtocol {
    func goToHome() {
        drawerVC.navigateTo(viewController: HomeViewController.getInstance())
    }
    func goToSettings() {
        drawerVC.navigateTo(viewController: SettingsViewController.getInstance())
    }
    func goToMap() {
        drawerVC.navigateTo(viewController: MapViewController.getInstance())
    }
    func goToHistoric() {
        drawerVC.navigateTo(viewController: HistoricViewController.getInstance())
    }
    func toggleMenu() {
        drawerVC.toggleMenu()
    }
}
