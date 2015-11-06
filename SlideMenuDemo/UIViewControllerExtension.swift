//
//  UIViewControllerExtension.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/21.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

extension UIViewController {

    func setNavigationBarItem() {
    
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)

        self.slideMenuController()?.addLeftGesture()

    }
    
    func removeNavigationItem() {
    
        self.navigationItem.leftBarButtonItem = nil
    }
    
     func toggleLeft() {
        
        slideMenuController()?.toggleLeft()
    }
    
    
     func openLeft() {
        
        slideMenuController()?.openLeft()
    }
    
     func closeLeft() {
        
        slideMenuController()?.closeLeft()
    }
    
}
