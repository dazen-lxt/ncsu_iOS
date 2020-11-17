//
//  UIApplication.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 11/8/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.windows[0].rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
