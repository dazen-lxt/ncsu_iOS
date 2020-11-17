//
//  RootViewController.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/12/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

protocol RootViewControllerDelegate: class {
    func rootViewControllerDidTapMenuButton(_ rootViewController: RootViewController)
}

class RootViewController: UINavigationController, UINavigationControllerDelegate {
    fileprivate var menuButton: UIBarButtonItem!
    weak var drawerDelegate: RootViewControllerDelegate?

    public init(mainViewController: UIViewController) {
        super.init(rootViewController: mainViewController)
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = UIColor.Brand.primaryColor
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let menuImageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        menuImageButton.setImage(UIImage(named: "hamburger-menu-icon"), for: .normal)
        menuImageButton.setImageColor(color: UIColor.white, for: .normal)
        menuImageButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        menuButton = UIBarButtonItem(customView: menuImageButton)
        menuButton.tintColor = UIColor.white
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        prepareNavigationBar()
    }
}

extension RootViewController {
    fileprivate func prepareNavigationBar() {
        topViewController?.navigationItem.title = topViewController?.title
        if self.viewControllers.count <= 1 {
            topViewController?.navigationItem.leftBarButtonItem = menuButton
        }
    }
}

extension RootViewController {
    @objc
    fileprivate func handleMenuButton() {
        drawerDelegate?.rootViewControllerDidTapMenuButton(self)
    }
}
