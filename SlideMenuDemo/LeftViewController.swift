//
//  LeftViewController.swift
//  SlideMenuDemo
//
//  Created by FrankLiu on 15/11/5.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let button: UIButton = UIButton(type: .Custom)
        button.backgroundColor = UIColor.orangeColor()
        button.setTitle("跳转", forState: .Normal)
        button.frame = CGRectMake(0, 80, 100, 40)
        view.addSubview(button)
        button.addTarget(self, action: "buttonAction", forControlEvents: .TouchUpInside)

    }
    
    func buttonAction() {
    
//        self.slideMenuController()?.changeMainViewController(self)
    }
}
