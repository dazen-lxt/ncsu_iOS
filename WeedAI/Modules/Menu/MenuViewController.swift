//
//  MenuViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/12/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit
import GoogleSignIn

class MenuViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var menuItems: [MenuItem] = []
    
    public weak var delegate: MenuViewControllerProtocol?
    
    public static func getInstance(delegate: MenuViewControllerProtocol) -> MenuViewController {
        let vc: MenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController()
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTable()
        setupGoogleInformation()
        setupMenu()
        NotificationCenter.default.addObserver(self, selector: #selector(googleUserDidChange(_:)), name:  NSNotification.Name(rawValue: Notifications.googleLogged), object: nil)
    }
    
    @objc func googleUserDidChange(_ notification: NSNotification) {
        setupGoogleInformation()
        setupMenu()
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupGoogleInformation() {
        emailLabel.text = GoogleManager.shared.email ?? ""
        nameLabel.text = GoogleManager.shared.userName ?? ""
    }
    
    private func setupMenu() {
        if(GoogleManager.shared.email != nil) {
            menuItems = [.home, .settings, .historic, .map, .logout]
        } else {
            menuItems = [.home, .settings, .login]
        }
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
    }
    
    enum MenuItem {
        case home, settings, historic, map, login, logout
    }
    
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let menuItem = menuItems[indexPath.row]
        switch menuItem {
        case .home:
            cell.configureCell(titleCell: "Home", imageName: "home_menu")
        case .settings:
            cell.configureCell(titleCell: "Settings", imageName: "settings_menu")
        case .historic:
            cell.configureCell(titleCell: "Historic", imageName: "historic_menu")
        case .map:
            cell.configureCell(titleCell: "Map", imageName: "map_menu")
        case .logout:
            cell.configureCell(titleCell: "Logout", imageName: "logout_menu")
        case .login:
            cell.configureCell(titleCell: "Login", imageName: "user_menu")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        switch menuItem {
        case .home:
            delegate?.goToHome()
        case .settings:
            delegate?.goToSettings()
        case .historic:
            delegate?.goToHistoric()
        case .map:
            delegate?.goToMap()
        case .login:
            GIDSignIn.sharedInstance()?.signIn()
        case .logout:
            GIDSignIn.sharedInstance()?.signOut()
            GoogleManager.shared.reset()
            setupGoogleInformation()
            setupMenu()
            delegate?.toggleMenu()
        }
    }
}

protocol MenuViewControllerProtocol: class {
    func goToHome()
    func goToSettings()
    func goToHistoric()
    func goToMap()
    func toggleMenu()
}
