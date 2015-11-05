//
//  SlideMenuController.swift
//  SlideMenuDemo
//
//  Created by 刘延峰 on 15/11/5.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

struct SlideMenuOptions {
    
    static var leftViewWidth:     CGFloat = 270
    static var animationDuration: CGFloat = 0.4
    static var contentViewScale:  CGFloat = 0.9
}

class SlideMenuController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: 变量
    var mainContainerView  = UIView()
    var leftContainerView  = UIView()
    var rightContainerView = UIView()
    var mainVC:  UIViewController?
    var leftVC:  UIViewController?
    var rightVC: UIViewController?
    
    var leftPanGesture:  UIPanGestureRecognizer?
    var rightPanGesture: UIPanGestureRecognizer?
    var leftTapGesture:  UITapGestureRecognizer?
    var rightTapGesture: UITapGestureRecognizer?
    
    // MARK: 基本初始化
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: 便利构造器
    convenience init(mainViewController: UIViewController, leftMenuViewController: UIViewController) {
    
        self.init()
        
        mainVC = mainViewController
        leftVC = leftMenuViewController
        
        initView()
        
    }
    
    convenience init(mainViewController: UIViewController, rightMenuViewController: UIViewController) {
    
        self.init()
        
        mainVC  = mainViewController
        rightVC = rightMenuViewController
        
        initView()
    }
    
    convenience init(mainViewController: UIViewController, leftMenuViewController: UIViewController, rightMenuViewController: UIViewController) {
    
        self.init()
        
        mainVC  = mainViewController
        leftVC  = leftMenuViewController
        rightVC = rightMenuViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func initView() {
    
        // mainContainView
        mainContainerView = UIView(frame: view.bounds)
        mainContainerView.backgroundColor = UIColor.clearColor()
        view.insertSubview(mainContainerView, atIndex: 0)
        
        // leftContainerView
        leftContainerView = UIView(frame: view.bounds)
        leftContainerView.backgroundColor = UIColor.clearColor()
        view.insertSubview(leftContainerView, atIndex: 1)
        
        // rightContainerView
        rightContainerView = UIView(frame: view.bounds)
        rightContainerView.backgroundColor = UIColor.clearColor()
        view.insertSubview(rightContainerView, atIndex: 2)
        
        addLeftGesture()
        addRightGesture()
    }
    
    // MARK: 手势相关方法
    func addLeftGesture() {
    
        if leftVC != nil {
        
            if leftTapGesture == nil {
            
                leftTapGesture = UITapGestureRecognizer(target: self, action: "toggleLeft")
                leftTapGesture?.delegate = self
                view.addGestureRecognizer(leftTapGesture!)
            }
            
            if leftPanGesture == nil {
            
                leftPanGesture = UIPanGestureRecognizer(target: self, action: "handleLeftPanGesture:")
                leftPanGesture?.delegate = self
                view.addGestureRecognizer(leftPanGesture!)
            }
            
        }
    }
    
    func addRightGesture() {
    
        if rightVC != nil {
        
            if rightTapGesture == nil {
            
                rightTapGesture = UITapGestureRecognizer(target: self, action: "toggleRight")
                rightTapGesture?.delegate = self
                view.addGestureRecognizer(rightTapGesture!)
            }
            
            if rightPanGesture == nil {
            
                rightPanGesture = UIPanGestureRecognizer(target: self, action: "handleRightPanGesture:")
                rightPanGesture?.delegate = self
                view.addGestureRecognizer(rightPanGesture!)
            }
        }
    }
    
    func toggleLeft() {
    
        if isLeftOpen() {
        
            closeLeft()
            
        } else {
         
            openLeft()
        }
    }
    
    func isLeftOpen() -> Bool {
    
        return leftContainerView.frame.origin.x == 0
    }
    
    func isLeftHidden() -> Bool {
    
        return leftContainerView.frame.origin.x <= leftMinOrigin()
    }
    
    func leftMinOrigin() -> CGFloat {
    
        return -SlideMenuOptions.leftViewWidth
    }
    
    func openLeft() {
    
        leftVC?.beginAppearanceTransition(isLeftHidden(), animated: true)
        openLeftWithVelocity(0)
    }
    
    func openLeftWithVelocity(velocity: CGFloat) {
    
        let xOrigin: CGFloat = leftContainerView.frame.origin.x
        let finalXOrigin: CGFloat = 0
        
        var frame = leftContainerView.frame
        
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(SlideMenuOptions.animationDuration)
        
        if velocity != 0 {
        
            duration = Double(fabs(xOrigin - finalXOrigin)/velocity)
            
            duration = Double(fmax(0.1, fmin(1, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { [weak self]() -> Void in
            
            if let strongSelf = self {
            
                strongSelf.leftContainerView.frame = frame
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(SlideMenuOptions.contentViewScale, SlideMenuOptions.contentViewScale)
            }
            
            }) { [weak self](Bool) -> Void in
                
                if let strongSelf = self {
                
                    
                }
        }
    }
    
    func closeLeft() {
    
        leftVC?.beginAppearanceTransition(isLeftHidden(), animated: true)
        closeLeftWithVelocity(0)
    }
    
    func closeLeftWithVelocity(velocity: CGFloat) {
    
        let xOrigin: CGFloat = leftContainerView.frame.origin.x
        let finalXOrigin: CGFloat = leftMinOrigin()
        
        var frame: CGRect = leftContainerView.frame
        frame.origin.x = finalXOrigin
        
        var duration: NSTimeInterval = Double(SlideMenuOptions.animationDuration)
        
        if velocity != 0 {
        
            duration = Double(fabs(xOrigin - finalXOrigin)/velocity)
            
            duration = Double(fmax(0.1, fmin(1, duration)))
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { [weak self]() -> Void in
            
            if let strongSelf = self {
            
                strongSelf.leftContainerView.frame = frame
                strongSelf.mainContainerView.transform = CGAffineTransformMakeScale(1, 1)
            }
            
            }) { [weak self](Bool) -> Void in
                
                if let strongSelf = self {
                    
                    
                }
                
        }
    }
    
    func toggleRight() {
    
    }
    
    func handleLeftPanGesture(panGesture: UIPanGestureRecognizer) {
    
        
    }
    
    func handleRightPanGesture(panGesture: UIPanGestureRecognizer) {
    
        
    }


}
